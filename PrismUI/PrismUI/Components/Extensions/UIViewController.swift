//
//  UIViewController.swift
//  PrismUI
//
//  Created by fanni suyuti on 6/12/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation

@objc internal protocol NavigationBarStyle {
    @objc func navigationItemDidTapLeftBarButtonItem()
    @objc func navigationItemDidTapRightBarButtonItem()
}

extension NavigationBarStyle where Self: UIViewController {
    
    func configureNavigationBar(title: String, subtitle: String, avatar: URL) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let newNavBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64))
        
        let backgroundView = UIView(frame: newNavBar.frame)
        backgroundView.backgroundColor = Settings.shared.theme.navigationBarColor
        newNavBar.addSubview(backgroundView)
        
        let item = UINavigationItem()
        
        let buttonImage = UIImage(named: "icBack", in: Bundle.init(identifier: "io.prismapp.PrismUI"), compatibleWith: nil)
        let button = UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: #selector(NavigationBarStyle.navigationItemDidTapLeftBarButtonItem))
        button.title = ""
        button.tintColor = .clear
        
        item.leftBarButtonItem = button
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.navigationTitleFont()
        titleLabel.textAlignment = .left
        titleLabel.sizeToFit()
        titleLabel.textColor = Settings.shared.theme.navigationBarTitleColor
        
        let subTitleLabel = UILabel()
        subTitleLabel.text = subtitle
        subTitleLabel.font = UIFont.navigationSubTitleFont()
        subTitleLabel.textAlignment = .left
        subTitleLabel.sizeToFit()
        subTitleLabel.textColor = Settings.shared.theme.navigationBarTitleColor
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 2, width: 32, height: 32))
        imageView.downloadedFrom(url: avatar)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        
        stackView.frame = CGRect(x: 44, y: 0, width: UIScreen.main.bounds.width * 290/375, height: 35)
        
        titleLabel.sizeToFit()
        subTitleLabel.sizeToFit()
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: stackView.bounds.width + 8 + imageView.bounds.width, height: 35))
        titleView.addSubview(imageView)
        titleView.addSubview(stackView)
        
        stackView.sizeToFit()
        
        item.titleView = titleView
        
        newNavBar.setItems([item], animated: false)
        
        view.addSubview(newNavBar)
    }
}

extension UIViewController: NavigationBarStyle {
    @objc func navigationItemDidTapRightBarButtonItem() {}
    @objc func navigationItemDidTapLeftBarButtonItem() {}
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
