//
//  ConnectViewController.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/8/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import PrismAnalytics

let formTextFieldHeight: CGFloat = 55

public class ConnectViewController: BaseViewController {
    
    @IBOutlet var helloLabel: UILabel!
    @IBOutlet var nameTF: LinedTextField!
    @IBOutlet var emailTF: LinedTextField!
    @IBOutlet var phoneTF: LinedTextField!
    @IBOutlet var startChatButton: UIButton!
    @IBOutlet var formContainerView: UIView!
    
    var viewModel: AuthViewModel
    
    public init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: Bundle.prism)
        
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTF.selectedColor = Settings.shared.theme.buttonColor
        emailTF.selectedColor = Settings.shared.theme.buttonColor
        phoneTF.selectedColor = Settings.shared.theme.buttonColor
        startChatButton.backgroundColor = Settings.shared.theme.buttonColor
        startChatButton.setTitle("START CHAT".localized(), for: .normal)
        
        let form = Settings.shared.connectForm
        update(textField: nameTF, form: form.username)
        update(textField: emailTF, form: form.email)
        update(textField: phoneTF, form: form.phoneNumber)
        
        KeyboardAvoiding.avoidingView = formContainerView
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        PrismAnalytics.shared.sendTracker(withEvent: .visitorConnect)
    }
    
    func update(textField: LinedTextField, form: InputForm) {
        textField.isRequired = form.required
        if form.show {
            textField.constraint(with: .height)?.constant = formTextFieldHeight
            textField.isHidden = false
        } else {
            textField.constraint(with: .height)?.constant = 0
            textField.isHidden = true
        }
    }
    
    @IBAction func startChatPressed(_ sender: UIButton) {
        guard nameTF.isValidUsername(),
            emailTF.isValidEmail(),
            phoneTF.isValidPhoneNumber() else { return }
        
        view.isUserInteractionEnabled = false
        startChatButton.startLoading()
        
        viewModel.visitorConnect(name: nameTF.text, email: emailTF.text, phoneNumber: phoneTF.text) { [weak self] (error) in
            if let error = error {
                print("Error: \(error)")
            } else {
                NotificationCenter.default.post(name: ConnectNotification, object: nil)
            }
        
            self?.view.isUserInteractionEnabled = true
            self?.startChatButton.stopLoading()
        }
    }
}
