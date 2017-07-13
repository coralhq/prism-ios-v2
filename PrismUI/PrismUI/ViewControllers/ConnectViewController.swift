//
//  ConnectViewController.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/8/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import PrismAnalytics

public class ConnectViewController: BaseViewController {
    
    @IBOutlet var nameTF: LinedTextField!
    @IBOutlet var emailTF: LinedTextField!
    @IBOutlet var phoneTF: LinedTextField!
    
    let fieldHeight: CGFloat = 55
    
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
        
        let formField = Settings.shared.inputForm        
        update(textField: nameTF, form: formField.username)
        update(textField: emailTF, form: formField.email)
        update(textField: phoneTF, form: formField.phoneNumber)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        PrismAnalytics.shared.sendTracker(withEvent: .visitorConnect)
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
        
        viewModel.visitorConnect(name: nameTF.text, email: emailTF.text, phoneNumber: phoneTF.text) { (error) in
            if let error = error {
                print("Error: \(error)")
            } else {
                NotificationCenter.default.post(name: ConnectNotification, object: nil)
            }
        }
    }
}
