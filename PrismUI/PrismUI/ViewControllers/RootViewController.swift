//
//  RootViewController.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/14/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    let viewModel = PrismViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(connectCalled(sender:)), name: ConnectNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disconnectCalled(sender:)), name: DisconnectNotification, object: nil)
        
        viewModel.getInputFormSettings { [weak self] (inputFormSettings, error) in
            guard let credential = self?.viewModel.credential else {
                guard let settings = inputFormSettings else {
                    return
                }

                let connectVC = ConnectViewController(settings: settings)
                self?.enter(viewController: connectVC, animated: false)
                return
            }
        }
    }
    
    func connectCalled(sender: Notification) {
        let credential = sender.object as? PrismCredential
    }
    
    func disconnectCalled(sender: Notification) {
        let settings = sender.object as? InputFormSettings
        let connectVC = ConnectViewController(settings: settings)
        enter(viewController: connectVC, animated: true)
    }
    
    private func enter(viewController vc: UIViewController, animated: Bool) {
        let currentVC = childViewControllers.first
        replace(vc1: currentVC, with: vc, animated: animated)
    }
}
