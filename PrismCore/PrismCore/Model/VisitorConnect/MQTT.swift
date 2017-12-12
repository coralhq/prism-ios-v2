//
//  MQTT.swift
//  PrismCoreSDK
//
//  Created by fanni suyuti on 5/19/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

//TODO: some properties might unused, re-check later
open class MQTT : NSObject, Mappable {
    public let username: String
    public let password: String
    
    required public init?(dictionary: [String: Any]?) {
        guard let username = dictionary?["username"] as? String,
            let password = dictionary?["password"] as? String
            else {
                return nil
        }
        
        self.username = username
        self.password = password
    }
    
    public func dictionaryValue() -> [String : Any] {
        return ["username": username,
                "password": password]
    }
}
