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
    
    func configureNavigationBar(theme: Theme, title: String, subtitle: String, avatar: URL) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        let newNavBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64))
        
        let backgroundView = UIView(frame: newNavBar.frame)
        backgroundView.backgroundColor = theme.navigationBarColor
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
        titleLabel.textColor = theme.navigationBarTitleColor
        
        let subTitleLabel = UILabel()
        subTitleLabel.text = subtitle
        subTitleLabel.font = UIFont.navigationSubTitleFont()
        subTitleLabel.textAlignment = .left
        subTitleLabel.sizeToFit()
        subTitleLabel.textColor = theme.navigationBarTitleColor
        
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
