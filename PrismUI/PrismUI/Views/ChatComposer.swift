//
//  ChatComposer.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/12/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

protocol ChatComposerDelegate: class {
    func chatComposer(composer: ChatComposer, didSendText text: String)
    func chatComposer(composer: ChatComposer, didSendSticker sticker: StickerViewModel)
}

class ChatComposer: UIView {
    
    @IBOutlet var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var botSpaceConstraint: NSLayoutConstraint!
    @IBOutlet var textView: UITextView!
    @IBOutlet var sendButton: SmallButton!
    
    weak var delegate: ChatComposerDelegate?
    var accessToken: String?
    
    static func composerFromNib(with accessToken: String) -> ChatComposer? {
        let view = ChatComposer.viewFromNib() as? ChatComposer
        view?.accessToken = accessToken
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow(sender:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide(sender:)), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewChanged(sender:)), name: .UITextViewTextDidChange, object: nil)
        
        botSpaceConstraint.constant = 0
        
        setText(text: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setText(text: String?) {
        textView.text = text
        
        if let text = text {
            sendButton.isEnabled = text.characters.count > 0
        } else {
            sendButton.isEnabled = false
        }
        
        let height = textView.sizeThatFits(CGSize(width: textView.bounds.width, height: 300)).height
        textViewHeightConstraint.constant = height
        textView.layoutIfNeeded()
    }
    
    @IBAction func textInputPressed(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            textView.inputView = EmojiInputView.viewFromNib(textView: textView)
        } else {
            textView.inputView = nil
        }
        textView.reloadInputViews()
    }
    
    @IBAction func attachImagePressed(sender: UIButton) {
        
    }
    
    @IBAction func stickerInputPressed(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        let inputView = StickerInputView.viewFromNib(accessToken: accessToken)
        inputView?.delegate = self
        
        textView.inputView = inputView
        textView.reloadInputViews()
    }
    
    @IBAction func sendPressed(sender: UIButton) {
        delegate?.chatComposer(composer: self, didSendText: textView.text)
        setText(text: nil)
    }
    
    func kbWillShow(sender: Notification) {
        guard let userInfo = sender.userInfo,
            let kbFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber else { return }
        
        UIView.animate(withDuration: duration.doubleValue, delay: 0, options: UIViewAnimationOptions(rawValue: curve.uintValue), animations: {
            let currentConstant = self.botSpaceConstraint.constant
            self.botSpaceConstraint.constant = kbFrame.cgRectValue.height - 20
            if currentConstant == 0 {
                self.superview?.superview?.layoutIfNeeded()
            }
        }, completion: nil)
    }
    
    func kbWillHide(sender: Notification) {
        guard let userInfo = sender.userInfo,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber else { return }
        
        UIView.animate(withDuration: duration.doubleValue, delay: 0, options: UIViewAnimationOptions(rawValue: curve.uintValue), animations: {
            self.botSpaceConstraint.constant = 0
            self.superview?.superview?.layoutIfNeeded()
        }, completion: nil)
    }
    
    func textViewChanged(sender: Notification) {
        setText(text: textView.text)
    }
}

extension ChatComposer: StickerInputViewDelegate {
    func stickerInputView(view: StickerInputView, didSend sticker: StickerViewModel) {
        delegate?.chatComposer(composer: self, didSendSticker: sticker)
    }
}
