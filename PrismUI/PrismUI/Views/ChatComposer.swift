//
//  ChatComposer.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/12/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

class ChatComposer: UIView {
    
    @IBOutlet var botSpaceConstraint: NSLayoutConstraint!
    @IBOutlet var textView: UITextView!    
    
    var emojiInputView: EmojiInputView?
    
    //    let keyboardView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 150))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow(sender:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide(sender:)), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewChanged(sender:)), name: .UITextViewTextDidChange, object: nil)
        
        emojiInputView = EmojiInputView.viewFromNib() as? EmojiInputView
        
        botSpaceConstraint.constant = 0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func textInputPressed(sender: UIButton) {
        textView.inputView = nil
        textView.reloadInputViews()
    }
    
    @IBAction func emojiInputPressed(sender: UIButton) {
        //        keyboardView.backgroundColor = UIColor.red
        textView.inputView = emojiInputView
        textView.reloadInputViews()
    }
    
    @IBAction func stickerInputPressed(sender: UIButton) {
        //        keyboardView.backgroundColor = UIColor.green
        textView.inputView = emojiInputView
        textView.reloadInputViews()
        
    }
    
    func kbWillShow(sender: Notification) {
        guard let userInfo = sender.userInfo,
            let kbFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber else { return }
        
        if var emojiFrame = emojiInputView?.frame {
            emojiFrame.size.height = kbFrame.cgRectValue.height
            emojiInputView?.frame = emojiFrame
        }
        
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
        
    }
}
