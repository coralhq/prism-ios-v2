//
//  RootViewController.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/14/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import PrismCore

class RootViewController: BaseViewController {
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var loadingIndicatorView: UIStackView!
    
    let viewModel = AuthViewModel()

    convenience init() {
        self.init(nibName: nil, bundle: Bundle.prism)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(connectCalled(sender:)), name: ConnectNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(disconnectCalled(sender:)), name: DisconnectNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshToken), name: RefreshTokenNotification, object: nil)
        
        loadingIndicator.startAnimating()
        loadingIndicatorView.isHidden = false

        viewModel.getSettings { [weak self] (settings) in
            guard settings != nil else {
                self?.dismiss(animated: true, completion: nil)
                return
            }
            
            guard let `self` = self else {
                return
            }
            
            if !Settings.shared.workingHour.isOnWorkingHour {
                let offlineVC = OfflineFormViewController(viewModel: self.viewModel)
                self.enter(viewController: offlineVC, animated: false)
                self.stopLoading()
                return
            }
            
            if let _ = Vendor.shared.credential {
                self.enterChatpage(animated: false)
                self.stopLoading()
                return
            }
            
            //New user, then clear previous data
            CoreDataManager.shared.clearData()
            CacheImage.shared.clearCache()
            Vendor.shared.credential = nil
            
            if Settings.shared.connectForm.enabled {
                
                let connectVC = ConnectViewController(viewModel: self.viewModel)
                self.enter(viewController: connectVC, animated: false)
                self.stopLoading()
                
            } else {
                
                self.viewModel.visitorConnectAnonymous(completion: { (error) in
                    self.enterChatpage(animated: false)
                    self.stopLoading()
                })
                
            }
        }
    }
    
    func stopLoading() {
        self.loadingIndicator.stopAnimating()
        loadingIndicatorView.isHidden = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    
    @objc func connectCalled(sender: Notification) {
        UIApplication.shared.registerForRemoteNotifications()        
        enterChatpage(animated: true)
    }
    
    @objc func disconnectCalled(sender: Notification) {
        let connectVC = ConnectViewController(viewModel: viewModel)
        enter(viewController: connectVC, animated: true)
    }
    
    private func enterChatpage(animated: Bool) {
        enter(viewController: ChatViewController(), animated: animated)
    }
    
    private func enter(viewController vc: UIViewController, animated: Bool) {
        let currentVC = childViewControllers.first
        replace(vc1: currentVC, with: vc, animated: animated)
    }
    
    func replace(vc1: UIViewController?, with vc2: UIViewController?, animated: Bool) {
        guard let vc2 = vc2 else { return }
        let nvc = UINavigationController(rootViewController: vc2)
        nvc.view.alpha = 0
        
        add(viewController: nvc, toView: view)
        
        if animated {
            UIView.animate(withDuration: 0.25, animations: {
                nvc.view.alpha = 1
            }, completion: { [weak self] (finished) in
                guard let vc = vc1 else { return }
                self?.remove(viewController: vc)
            })
        } else {
            nvc.view.alpha = 1
            guard let vc = vc1 else { return }
            remove(viewController: vc)
        }
    }
}
