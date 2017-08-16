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
    @IBOutlet var abcButton: SmallButton!
    @IBOutlet var stickerButton: SmallButton!
    
    weak var delegate: ChatComposerDelegate?
    var accessToken: String?
    
    /*
     This UITextView purpose is only as StickerInputView container. It'll and must not shown on the screen
     */
    let fakeTextView = UITextView()
    
    static func composerFromNib(with accessToken: String) -> ChatComposer? {
        let view: ChatComposer? = ChatComposer.viewFromNib()
        view?.accessToken = accessToken
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textView.delegate = self
        
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
    
    @IBAction func abcPressed(sender: UIButton) {
        abcButton.isHidden = true
        emojiButton.isHidden = false
        
        textView.inputView = nil
        textView.reloadInputViews()
        
        if textView.becomeFirstResponder() == false {
            textView.becomeFirstResponder()
        }
    }
    
    @IBAction func emojiPressed(sender: UIButton) {
        abcButton.isHidden = false
        emojiButton.isHidden = true
        
        textView.inputView = EmojiInputView.viewFromNib(with: textView)
        textView.reloadInputViews()
        
        if textView.becomeFirstResponder() == false {
            textView.becomeFirstResponder()
        }
    }
    
    @IBAction func stickerInputPressed(sender: UIButton) {
        if fakeTextView.superview == nil {
            fakeTextView.delegate = self
            fakeTextView.isHidden = true
            addSubview(fakeTextView)
        }
        
        if fakeTextView.inputView == nil {
            let inputView = StickerInputView.viewFromNib(accessToken: accessToken)
            inputView?.delegate = self
            fakeTextView.inputView = inputView
            fakeTextView.reloadInputViews()
        }
        
        if fakeTextView.becomeFirstResponder() == false {
            fakeTextView.becomeFirstResponder()
        }
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
        picker.dismiss(animated: true, completion: nil)
        
        DispatchQueue(label: "resize_queue").async { [weak self] in
            guard let `self` = self,
                let image = info[UIImagePickerControllerOriginalImage] as? UIImage,
                let imageURL = info[UIImagePickerControllerReferenceURL] as? URL,
                let asset = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil).firstObject,
                let imageName = asset.value(forKey: "filename") as? String else {
                    return
            }
            
            let finalImage = image.resize(targetSize: CGSize(width: 1500, height: 1500))
            
            DispatchQueue.main.async {
                self.delegate?.chatComposer(composer: self, didPickImage: finalImage, imageName: imageName)
            }
        }
    }
}

extension ChatComposer: StickerInputViewDelegate {
    func stickerInputView(view: StickerInputView, didSend sticker: StickerViewModel) {
        delegate?.chatComposer(composer: self, didPickSticker: sticker)
    }
}

extension ChatComposer: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if fakeTextView == textView {
            stickerButton.setImage(UIImage(named: "icBtnStickerSelected", in: Bundle.prism, compatibleWith: nil), for: .normal)
        } else {
            emojiButton.tintColor = Settings.shared.theme.buttonColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.inputView = nil
        
        if fakeTextView == textView {
            stickerButton.setImage(UIImage(named: "icBtnSticker", in: Bundle.prism, compatibleWith: nil), for: .normal)
        } else {
            abcButton.isHidden = true
            emojiButton.isHidden = false
            emojiButton.tintColor = UIColor.jetBlack.withAlphaComponent(0.8)
        }
    }
}
