//
//  OfflineFormViewController.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 7/17/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import PrismCore

class OfflineFormViewController: BaseViewController {
    @IBOutlet var nameTF: LinedTextField!
    @IBOutlet var emailTF: LinedTextField!
    @IBOutlet var phoneTF: LinedTextField!
    @IBOutlet var messageTF: LinedTextField!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var offlineFormLabel: UILabel!
    
    let chatManager: ChatManager = ChatManager()
    let viewModel: AuthViewModel
    
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: Bundle.prism)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        offlineFormLabel.text = Settings.shared.offlineWidget.offlineMessage
        
        nameTF.selectedColor = Settings.shared.theme.buttonColor
        emailTF.selectedColor = Settings.shared.theme.buttonColor
        phoneTF.selectedColor = Settings.shared.theme.buttonColor
        messageTF.selectedColor = Settings.shared.theme.buttonColor
        sendButton.backgroundColor = Settings.shared.theme.buttonColor
        
        let formField = Settings.shared.inputForm
        update(textField: nameTF, form: formField.username)
        update(textField: emailTF, form: formField.email)
        update(textField: phoneTF, form: formField.phoneNumber)
    }
    
    func update(textField: LinedTextField, form: InputForm) {
        textField.isRequired = true
        if form.show {
            textField.constraint(with: .height)?.constant = formTextFieldHeight
            textField.isHidden = false
        } else {
            textField.constraint(with: .height)?.constant = 0
            textField.isHidden = true
        }
    }
    
    @IBAction func sendMessagePressed(_ sender: UIButton) {
        guard messageTF.isValidMessage(),
            nameTF.isValidUsername(),
            emailTF.isValidEmail(),
            phoneTF.isValidPhoneNumber(),
            let name = nameTF.text,
            let email = emailTF.text,
            let phone = phoneTF.text,
            let message = messageTF.text else { return }
        
        view.isUserInteractionEnabled = false
        sendButton.startLoading()
        
        if Vendor.shared.credential == nil {
            viewModel.visitorConnect(name: nameTF.text, email: emailTF.text, phoneNumber: phoneTF.text) { [weak self] (error) in
                guard let `self` = self else {
                    return
                }
                
                if let _ = error {
                    self.sendButton.stopLoading()
                    self.view.isUserInteractionEnabled = true
                    return
                }
                
                self.sendOfflineMessage(name: name, email: email, phone: phone, message: message, completion: { (success) in
                    self.sendButton.stopLoading()
                    self.view.isUserInteractionEnabled = true
                })
            }
        } else {
            self.sendOfflineMessage(name: name, email: email, phone: phone, message: message, completion: { [weak self] (success) in
                self?.sendButton.stopLoading()
                self?.view.isUserInteractionEnabled = true
            })
        }
    }
    
    private func sendOfflineMessage(name: String, email: String, phone: String, message: String, completion: ((Bool) -> ())?) {
        self.chatManager.sendOfflineMessage(with: name, email: email, phone: phone, message: message) { [weak self] (response, error) in
            guard error == nil else {
                completion?(false)
                return
            }
            let vc = OfflineMessageViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
            completion?(true)
        }
    }
}
