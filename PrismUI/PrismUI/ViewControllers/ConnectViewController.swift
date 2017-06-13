//
//  ConnectViewController.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/8/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import PrismCore

extension UITableViewCell {
    static var NIB: UINib {
        return UINib.init(nibName: self.name, bundle: Bundle.prism)
    }
}

public class ConnectViewController: UIViewController {
    
    @IBOutlet var nameTF: TextField!
    @IBOutlet var emailTF: TextField!
    @IBOutlet var phoneTF: TextField!
    
    let fieldHeight: CGFloat = 55
    var formFields: [String: Any]
    
    public init(formFields: [String: Any]) {
        self.formFields = formFields
        super.init(nibName: ConnectViewController.name, bundle: Bundle.prism)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        for (key, value) in formFields {
            guard let value = value as? [String: Any],
                let show = value["show"] as? Bool,
                let required = value["required"] as? Bool else {
                    continue
            }
            
            if key == "name"{
                update(textField: nameTF, show: show, required: required)
            } else if key == "email" && show {
                update(textField: emailTF, show: show, required: required)
            } else {
                update(textField: phoneTF, show: show, required: required)
            }
        }
    }
    
    func update(textField: TextField, show: Bool, required: Bool) {
        textField.isRequired = required
        if show {
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
        
        PrismCore.shared.visitorConnect(name: nameTF.text, email: emailTF.text, phoneNumber: phoneTF.text) { (response, error) in
            
            if let error = error {
                print("Error: \(error)")
            } else {
                if let visitor = response?.visitor {
                    Utils.archive(object: visitor, key: "visitor")
                }
                
                let chatVC = ChatViewController(nibName: ChatViewController.name, bundle: nil)
                self.navigationController?.pushViewController(chatVC, animated: true)
            }
        }
    }
}
