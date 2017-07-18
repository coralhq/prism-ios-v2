//
//  RootViewController.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/14/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import PrismCore
import PrismAnalytics

class RootViewController: BaseViewController {
    let viewModel = AuthViewModel()
    var chatManager: ChatManager? = nil
    
    convenience init() {
        self.init(nibName: nil, bundle: Bundle.prism)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(connectCalled(sender:)), name: ConnectNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disconnectCalled(sender:)), name: DisconnectNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshToken), name: RefreshTokenNotification, object: nil)
        
        viewModel.getSettings { [unowned self] (settings) in
            if let _ = Vendor.shared.credential {
                self.enterChatpage(animated: false)
            } else {
                if Settings.shared.inputForm.enabled {
                    let connectVC = ConnectViewController(viewModel: self.viewModel)
                    self.enter(viewController: connectVC, animated: false)
                } else {
                    self.viewModel.visitorConnectAnonymous(completion: { (error) in
                        self.enterChatpage(animated: false)
                    })
                }
            }
        }
    }
    
    @objc private func refreshToken() {
        guard let credential = Vendor.shared.credential else {
            return
        }
        PrismCore.shared.refreshToken(clientID: credential.clientID, refreshToken: credential.refreshToken, completionHandler: { [weak self] (refreshTokenResponse, error) in
            guard let refreshTokenResponse = refreshTokenResponse, error == nil else {
                self?.showVisitorConnect()
                return
            }
            
            credential.accessToken = refreshTokenResponse.oAuth.accessToken
            credential.clientID = refreshTokenResponse.oAuth.clientID
            credential.refreshToken = refreshTokenResponse.oAuth.refreshToken
            
        })
    }
    
    private func showVisitorConnect() {
        let viewModel = AuthViewModel()
        let vc = ConnectViewController(viewModel: viewModel)
        
        let currentVC = childViewControllers.first
        replace(vc1: currentVC, with: vc, animated: true)
    }
    
    func connectCalled(sender: Notification) {
        enterChatpage(animated: true)
    }
    
    func disconnectCalled(sender: Notification) {
        let connectVC = ConnectViewController(viewModel: viewModel)
        enter(viewController: connectVC, animated: true)
    }
    
    private func enterChatpage(animated: Bool) {
        if chatManager == nil {
            chatManager = ChatManager()
        }
        
        if Settings.shared.workingHour.isOnWorkingHour {
            let chatVC = ChatViewController(with: chatManager!)
            enter(viewController: chatVC, animated: animated)
        } else {
            let offlineVC = OfflineFormViewController(with: chatManager!)
            enter(viewController: offlineVC, animated: animated)
        }
    }
    
    private func enter(viewController vc: UIViewController, animated: Bool) {
        chatManager = nil
        
        let currentVC = childViewControllers.first
        replace(vc1: currentVC, with: vc, animated: animated)
    }
}
