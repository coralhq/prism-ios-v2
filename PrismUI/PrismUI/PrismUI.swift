//
//  PrismUI.swift
//  PrismUI
//
//  Created by fanni suyuti on 6/9/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import PrismCore

public protocol PrismUIDelegate {
    func didReceive(message data: Data, in topic: String)
}

open class PrismUI {
    
    open static var shared = PrismUI()
    private init() {}
    
    var delegate: PrismUIDelegate?
    
    open func configure(environment: EnvironmentType, merchantID: String, delegate: PrismUIDelegate) {
        self.delegate = delegate
        
        PrismCore.shared.configure(environment: environment, merchantID: merchantID, delegate: self)
    }
    
    open func getSetting(completionHandler: @escaping ([String: Any]) -> ()) {
        
        PrismCore.shared.getSettings { (response, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            UserDefaults.standard.set(response, forKey: "merchant_setting")
            completionHandler(response!)
        }
    }
}

extension PrismUI: PrismCoreDelegate {
    public func didReceive(message data: Data, in topic: String) {
        delegate?.didReceive(message: data, in: topic)
    }
}
