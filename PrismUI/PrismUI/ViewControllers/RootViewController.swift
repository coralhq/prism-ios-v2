//
//  RootViewController.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/14/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    let viewModel = AuthViewModel()
    
    convenience init() {
        self.init(nibName: nil, bundle: Bundle.prism)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(connectCalled(sender:)), name: ConnectNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disconnectCalled(sender:)), name: DisconnectNotification, object: nil)
        
        viewModel.getSettings { [unowned self] (settings) in
            Settings.shared.configure(settings: settings)
            
            if let credential = self.viewModel.credential {
                self.enterChatpage(credential: credential, animated: false)
            } else {
                if Settings.shared.inputForm.enabled {
                    let connectVC = ConnectViewController(viewModel: self.viewModel)
                    self.enter(viewController: connectVC, animated: false)
                } else {
                    self.viewModel.visitorConnectAnonymous(completion: { (credential, error) in
                        guard let credential = credential else { return }
                        self.enterChatpage(credential: credential, animated: false)
                    })
                }
            }
        }
    }
    
    func connectCalled(sender: Notification) {
        guard let credential = sender.object as? PrismCredential else { return }
        enterChatpage(credential: credential, animated: true)
    }
    
    func disconnectCalled(sender: Notification) {
        let connectVC = ConnectViewController(viewModel: viewModel)
        enter(viewController: connectVC, animated: true)
    }
    
    private func enterChatpage(credential: PrismCredential, animated: Bool) {
        let chatVC = ChatViewController(credential: credential)
        enter(viewController: chatVC, animated: animated)
    }
    
    private func enter(viewController vc: UIViewController, animated: Bool) {
        let currentVC = childViewControllers.first
        replace(vc1: currentVC, with: vc, animated: animated)
    }
}
