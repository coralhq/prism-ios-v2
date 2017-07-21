//
//  UIViewController.swift
//  PrismUI
//
//  Created by fanni suyuti on 6/12/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation

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
    
    static var root: UIViewController? {
        var rootVC = UIApplication.shared.keyWindow?.rootViewController
        while (rootVC?.presentedViewController != nil) {
            if let presentedVC = rootVC?.presentedViewController,
                presentedVC.isKind(of: UIAlertController.classForCoder()) == false {
                rootVC = rootVC?.presentedViewController
            } else {
                break
            }
        }
        
        if let navVC = rootVC as? UINavigationController {
            return navVC.topViewController
        } else if let tabVC = rootVC as? UITabBarController {
            if let navVC = tabVC.selectedViewController as? UINavigationController {
                return navVC.topViewController
            } else {
                return tabVC.selectedViewController
            }
        } else {
            return rootVC
        }
    }
}
