//
//  UITextField.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/18/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation

extension LinedTextField {
    func isValidMessage() -> Bool {
        warning = nil
        var result: Bool
        
        if let char = text?.characters,
            char.count > 0 {
            result = true
        } else {
            if isRequired {
                warning = "message is required".localized()
                result = false
            } else {
                result = true
            }
        }
        return result || isHidden
    }
    
    func isValidUsername() -> Bool {
        warning = nil
        var result: Bool
        
        if let char = text?.characters,
            char.count > 0 {
            result = true
        } else {
            if isRequired {
                warning = "name is required".localized()
                result = false
            } else {
                result = true
            }
        }
        return result || isHidden
    }
    
    func isValidEmail() -> Bool {
        warning = nil
        var result: Bool
        
        if let char = text?.characters,
            char.count > 0 {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            if emailTest.evaluate(with: self.text) {
                result = true
            } else {
                warning = "email is invalid".localized()
                result = false
            }
        } else {
            if isRequired {
                warning = "email is required".localized()
                result = false
            } else {
                result = true
            }
        }
        return result || isHidden
    }
    
    func isValidPhoneNumber() -> Bool {
        warning = nil
        var result: Bool
        
        if let char = text?.characters,
            char.count > 0 {
            let regex = "^\\d+$"
            let tester = NSPredicate.init(format: "SELF MATCHES %@", regex)
            if tester.evaluate(with: self.text) {
                result = true
            } else {
                warning = "phone number is invalid".localized()
                result = false
            }
        } else {
            if isRequired {
                warning = "phone number is required".localized()
                result = false
            } else {
                result = true
            }
        }
        return result || isHidden
    }
}
