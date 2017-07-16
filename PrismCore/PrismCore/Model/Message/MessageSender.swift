//
//  MessageSender.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

public class MessageSender : Mappable {
    public var id: String
    public var name: String
    public var role: String
    public var userAgent: String
    
    required public init?(dictionary: [String : Any]?) {
        guard let id = dictionary?["id"] as? String,
            let name = dictionary?["name"] as? String,
            let role = dictionary?["role"] as? String,
            let userAgent = dictionary?["user_agent"] as? String else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.role = role
        self.userAgent = userAgent
    }
    
    
    convenience public init?(id: String, name: String, role: String, userAgent: String) {
        let data = ["id": id, "name": name, "role": role, "user_agent": userAgent ]
        self.init(dictionary: data)
    }
    
    public func dictionaryValue() -> [String : Any] {
        return ["id": id,
                "name": name,
                "role": role,
                "user_agent": userAgent]
    }
}
