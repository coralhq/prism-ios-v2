//
//  MessageSender.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

public class MessageSender : Mappable {
    var id: String
    var name: String
    var role: String
    var userAgent: String
    
    required public init?(json: [String : Any]?) {
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
    
    
    convenience public init?(id: String, name: String, role: String, userAgent: String) {
        let data = ["id": id, "name": name, "role": role, "user_agent": userAgent ]
        self.init(json: data)
    }
}
