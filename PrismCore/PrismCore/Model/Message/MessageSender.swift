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
    public var appName: String?
    
    required public init?(dictionary: [String : Any]?) {
        guard let id = dictionary?["id"] as? String,
            let name = dictionary?["name"] as? String,
            let role = dictionary?["role"] as? String else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.role = role
        
        appName = dictionary?["app_name"] as? String
    }
    
    
    convenience public init?(id: String, name: String, role: String, appName: String) {
        let data = ["id": id, "name": name, "role": role, "app_name": appName ]
        self.init(dictionary: data)
    }
    
    public func dictionaryValue() -> [String : Any] {
        return ["id": id,
                "name": name,
                "role": role,
                "app_name": appName ?? ""]
    }
}
