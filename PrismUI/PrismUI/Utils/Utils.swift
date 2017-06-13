//
//  Utils.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/9/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation

class Utils {
    static func archive(object: Any, key: String) {
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(data, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func unarchive(key: String) -> Any? {
        guard let data = UserDefaults.standard.value(forKey: key) as? Data else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: data)
    }
}

extension UIView {
    func constraint(with attribute: NSLayoutAttribute) -> NSLayoutConstraint? {
        let filteredArray = constraints.filter { (constraint) -> Bool in
            return constraint.firstAttribute == attribute
        }
        return filteredArray.first
    }
}

extension TextField {
    func isValidUsername() -> Bool {
        warning = nil
        
        if let char = text?.characters,
            char.count > 0 {
            return true
        } else {
            if isRequired {
                warning = "name is required"
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
                warning = "email is invalid"
                return false
            }
        } else {
            if isRequired {
                warning = "email is required"
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
                warning = "phone number is invalid"
                return false
            }
        } else {
            if isRequired {
                warning = "phone number is required"
                return false
            } else {
                return true
            }
        }
    }
}

extension Bundle {
    static var prism: Bundle {
        return Bundle(for: ConnectViewController.classForCoder())
    }
}

extension NSObject {
    static var name: String {
        get {
            return String(describing: self)
        }
    }
}
