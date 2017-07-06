//
//  UITextField.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/18/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation

extension LinedTextField {
    func isValidUsername() -> Bool {
        warning = nil
        
        if let char = text?.characters,
            char.count > 0 {
            return true
        } else {
            if isRequired {
                warning = "name is required".localized()
                return false
            } else {
                return true
            }
        }
    }
    
    func isValidEmail() -> Bool {
        warning = nil
        
        if let char = text?.characters,
            char.count > 0 {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            if emailTest.evaluate(with: self) {
                return true
            } else {
                warning = "email is invalid".localized()
                return false
            }
        } else {
            if isRequired {
                warning = "email is required".localized()
                return false
            } else {
                return true
            }
        }
    }
    
    func isValidPhoneNumber() -> Bool {
        warning = nil
        
        if let char = text?.characters,
            char.count > 0 {
            let regex = "^[0-9]{3}-[0-9]{3}-[0-9]{4}$"
            let tester = NSPredicate.init(format: "SELF MATCHES %@", regex)
            if tester.evaluate(with:self) {
                return true
            } else {
                warning = "phone number is invalid".localized()
                return false
            }
        } else {
            if isRequired {
                warning = "phone number is required".localized()
                return false
            } else {
                return true
            }
        }
    }
}
