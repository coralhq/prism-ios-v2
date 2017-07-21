//
//  ChatComposer.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/12/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import PrismAnalytics
import Photos

protocol ChatComposerDelegate: class {
    func chatComposer(composer: ChatComposer, didComposeText text: String)
    func chatComposer(composer: ChatComposer, didPickSticker sticker: StickerViewModel)
    func chatComposer(composer: ChatComposer, didPickImage image: UIImage, imageName: String)
}

class ChatComposer: UIView {
    
    @IBOutlet var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var botSpaceConstraint: NSLayoutConstraint!
    @IBOutlet var textView: UITextView!
    @IBOutlet var sendButton: SmallButton!
    @IBOutlet var topSeparatorView: UIView!
    @IBOutlet var emojiButton: SmallButton!
    @IBOutlet var stickerButton: SmallButton!
    
    weak var delegate: ChatComposerDelegate?
    var accessToken: String?
    
    static func composerFromNib(with accessToken: String) -> ChatComposer? {
        let view: ChatComposer? = ChatComposer.viewFromNib()
        view?.accessToken = accessToken
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        topSeparatorView.backgroundColor = Settings.shared.theme.buttonColor.withAlphaComponent(0.15)
        
        sendButton.color = Settings.shared.theme.buttonColor
        sendButton.disabledColor = Settings.shared.theme.buttonColor.withAlphaComponent(0.5)
        
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
        if textView.becomeFirstResponder() == false {
            textView.becomeFirstResponder()
        }
        
        stickerButton.isSelected = false
        emojiButton.isSelected = !emojiButton.isSelected
        
        if sender.isSelected {
            textView.inputView = EmojiInputView.viewFromNib(with: textView)
        } else {
            textView.inputView = nil
        }
        textView.reloadInputViews()
    }
    
    @IBAction func stickerInputPressed(sender: UIButton) {
        if textView.becomeFirstResponder() == false {
            textView.becomeFirstResponder()
        }
        
        emojiButton.isSelected = false
        stickerButton.isSelected = !stickerButton.isSelected
        
        if sender.isSelected {
            let inputView = StickerInputView.viewFromNib(accessToken: accessToken)
            inputView?.delegate = self
            textView.inputView = inputView
        } else {
            textView.inputView = nil
        }
        textView.reloadInputViews()
    }
    
    @IBAction func attachImagePressed(sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        UIViewController.root?.present(picker, animated: true, completion: nil)
        
        PrismAnalytics.shared.sendTracker(withEvent: .uploadImageClicked)
    }
    
    @IBAction func sendPressed(sender: UIButton) {
        delegate?.chatComposer(composer: self, didComposeText: textView.text)
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

extension ChatComposer: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let imageURL = info[UIImagePickerControllerReferenceURL] as? URL,
            let asset = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil).firstObject,
            let imageName = asset.value(forKey: "filename") as? String else {
                return
        }
        
        picker.dismiss(animated: true, completion: nil)
        delegate?.chatComposer(composer: self, didPickImage: image, imageName: imageName)
    }
}

extension ChatComposer: StickerInputViewDelegate {
    func stickerInputView(view: StickerInputView, didSend sticker: StickerViewModel) {
        delegate?.chatComposer(composer: self, didPickSticker: sticker)
    }
}
