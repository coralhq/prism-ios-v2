//
//  UIViewControllerExt.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/18/17.
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
