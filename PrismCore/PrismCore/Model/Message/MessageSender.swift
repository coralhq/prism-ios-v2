//
//  MessageSender.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

class MessageSender : Mappable {
    var id: String
    var name: String
    var role: String
    var userAgent: String
    
    required init?(json: [String : Any]?) {
        guard let id = json?["id"] as? String,
            let name = json?["name"] as? String,
            let role = json?["role"] as? String,
            let userAgent = json?["user_agent"] as? String else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.role = role
        self.userAgent = userAgent
    }
}
