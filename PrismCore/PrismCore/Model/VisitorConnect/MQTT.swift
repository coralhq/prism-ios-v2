//
//  MQTT.swift
//  PrismCoreSDK
//
//  Created by fanni suyuti on 5/19/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

//TODO: some properties might unused, re-check later
public class MQTT : Mappable {
    public let username: String
    public let password: String
    
    required public init?(json: [String: Any]?) {
        guard let username = json?["username"] as? String,
            let password = json?["password"] as? String
            else {
                return nil
        }
        
        self.username = username
        self.password = password
    }
}
