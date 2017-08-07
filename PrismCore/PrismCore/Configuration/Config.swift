//
//  Config.swift
//  PrismCoreSDK
//
//  Created by fanni suyuti on 5/18/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

public enum EnvironmentType {
    case Sandbox
    case Production
    case Staging
}

internal class Config {
    
    static var shared = Config()
    
    fileprivate var environment: EnvironmentType = .Staging
    fileprivate var merchantID: String?
    
    private init () {}
    
    func configure(environment: EnvironmentType, merchantID: String) {
        self.environment = environment
        self.merchantID = merchantID
    }
    
    func getEnvironment() -> EnvironmentType? {
        return environment
    }
    
    func getMerchantID() -> String? {
        return merchantID
    }
}
