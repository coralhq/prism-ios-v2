//
//  ViewUtils.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/15/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation

extension NSObject {
    static var name: String {
        get {
            return String(describing: self)
        }
    }
}

extension UIViewController {
    func popErrorAlert(error: NSError) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func remove(viewController vc:UIViewController) -> Void {
        vc.view.removeFromSuperview()
        vc.removeFromParentViewController()
        vc.didMove(toParentViewController: nil)
    }
    
    func add(viewController vc:UIViewController, toView contentView:UIView) -> Void {
        self.addChildViewController(vc)
        vc.didMove(toParentViewController: self)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(vc.view)
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: .init(rawValue: 0), metrics: nil, views: ["view":vc.view]))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: .init(rawValue: 0), metrics: nil, views: ["view":vc.view]))
    }
    
    func replace(vc1: UIViewController?, with vc2: UIViewController?, animated: Bool) {
        guard let vc2 = vc2 else { return }
        let nvc = UINavigationController(rootViewController: vc2)
        nvc.view.alpha = 0
        
        add(viewController: nvc, toView: view)
        
        if animated {
            UIView.animate(withDuration: 0.25, animations: {
                nvc.view.alpha = 1
            }, completion: { (finished) in
                guard let vc = vc1 else { return }
                self.remove(viewController: vc)
            })
        } else {
            nvc.view.alpha = 1
            guard let vc = vc1 else { return }
            remove(viewController: vc)
        }
    }
}

extension Bundle {
    static var prism: Bundle {
        return Bundle(for: ConnectViewController.classForCoder())
    }
}

extension UITableViewCell {
    static var NIB: UINib {
        return UINib.init(nibName: self.name, bundle: Bundle.prism)
    }
}

extension LinedTextField {
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

extension UIView {
    func constraint(with attribute: NSLayoutAttribute) -> NSLayoutConstraint? {
        let filteredArray = constraints.filter { (constraint) -> Bool in
            return constraint.firstAttribute == attribute
        }
        return filteredArray.first
    }
}
