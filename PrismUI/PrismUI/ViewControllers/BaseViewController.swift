//
//  BaseViewController.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/15/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

extension UIImage {
    static func image(with name: String) -> UIImage? {
        return UIImage(named: name, in: Bundle.prism, compatibleWith: nil)
    }
}

class BaseViewController: UIViewController {

    convenience init() {
        self.init(nibName: nil, bundle: Bundle.prism)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = Settings.shared.theme.headerColor
        navigationController?.navigationBar.tintColor = Settings.shared.theme.strokeColor
        
        let header: HeaderView = HeaderView.viewFromNib()!
        header.configure(settings: Settings.shared)
        let title = UIBarButtonItem(customView: header)
        let backBtn = UIBarButtonItem(image: UIImage.image(with: "icBack"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(closePressed(sender:)))
        navigationItem.leftBarButtonItems = [backBtn, title]

        automaticallyAdjustsScrollViewInsets = false
        extendedLayoutIncludesOpaqueBars = false
        edgesForExtendedLayout = .init(rawValue: 0)
    }
    
    func closePressed(sender: UIBarButtonItem) {
        view.endEditing(true)
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        if Settings.shared.theme.headerColor == UIColor.white {
            return .default
        } else {
            return .lightContent
        }
    }
}
