//
//  PrismUI.swift
//  PrismUI
//
//  Created by fanni suyuti on 6/9/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import PrismCore
import PrismAnalytics

public protocol PrismUIDelegate {
    func didReceive(message data: Data, in topic: String)
}

open class PrismUI {
    
    open static var shared = PrismUI()
    private init() {}
    
    var delegate: PrismUIDelegate?
    
    open func configure(environment: EnvironmentType, merchantID: String, delegate: PrismUIDelegate) {
        self.delegate = delegate
        PrismCore.shared.configure(environment: environment, merchantID: merchantID)
        
        let analyticsEnv = environment == .Production ? AnalyticEnvironment.Production : AnalyticEnvironment.Sandbox
        PrismAnalytics.shared.configure(environment: analyticsEnv)
    }
    
    open func present(on viewController: UIViewController) {
        let rootVC = RootViewController()
        viewController.present(rootVC, animated: true, completion: nil)
    }
}

extension PrismUI: PrismCoreDelegate {
    public func didReceive(message data: Data, in topic: String) {
        delegate?.didReceive(message: data, in: topic)
    }
}
