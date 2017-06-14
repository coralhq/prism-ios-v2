//
//  ConnectViewController.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/8/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

public class ConnectViewController: UIViewController {
    
    @IBOutlet var nameTF: LinedTextField!
    @IBOutlet var emailTF: LinedTextField!
    @IBOutlet var phoneTF: LinedTextField!
    
    let fieldHeight: CGFloat = 55
    let settings: InputFormSettings?
    let viewModel = PrismViewModel()
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(settings: InputFormSettings?) {
        self.settings = settings
        super.init(nibName: ConnectViewController.name, bundle: Bundle.prism)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if let settings = settings {
            update(textField: nameTF, form: settings.username)
            update(textField: emailTF, form: settings.email)
            update(textField: phoneTF, form: settings.phoneNumber)
        }
    }
    
    func update(textField: LinedTextField, form: InputForm) {
        textField.isRequired = form.required
        if form.show {
            textField.constraint(with: .height)?.constant = fieldHeight
            textField.isHidden = false
        } else {
            textField.constraint(with: .height)?.constant = 0
            textField.isHidden = true
        }
    }
    
    @IBAction func startChatPressed(_ sender: UIButton) {
        guard let nameTF = nameTF,
            let emailTF = emailTF,
            let phoneTF = phoneTF,
            nameTF.isValidUsername(),
            emailTF.isValidEmail(),
            phoneTF.isValidPhoneNumber() else { return }
        
        viewModel.connect(name: nameTF.text, email: emailTF.text, phoneNumber: phoneTF.text) { (credential, error) in
            if let error = error {
                print("Error: \(error)")
            } else {
                NotificationCenter.default.post(name: ConnectNotification, object: credential)                
            }
        }
    }
}
