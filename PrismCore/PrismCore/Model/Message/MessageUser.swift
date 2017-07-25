//
//  MessageUser.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

public class MessageUser: Mappable {
    public let id: String
    public let name: String
    
    required public init?(dictionary: [String : Any]?) {
        guard let id = dictionary?["id"] as? String,
            let name = dictionary?["name"] as? String else {
                return nil
        }
        
        self.id = id
        self.name = name
    }
    
    convenience public init?(id: String, name: String) {
        let data = ["id": id, "name": name ]
        self.init(dictionary: data)
    }
    
    public func dictionaryValue() -> [String : Any] {
        return [
            "id": id,
            "name": name
        ]
    }
}

public class MessageChannelInfo: Mappable {
    public let id: String
    public let name: String
    public let attribute: [String: Any]?
    
    required public init?(dictionary: [String : Any]?) {
        guard let id = dictionary?["id"] as? String,
            let name = dictionary?["name"] as? String else {
                return nil
        }
        
        attribute = dictionary?["attribute"] as? [String: Any]
        
        self.id = id
        self.name = name
    }
    
    convenience public init?(id: String, name: String, attribute: [String: Any]? = nil) {
        
        var data: [String: Any]
        
        if let attribute = attribute {
            data = ["id": id, "name": name , "attribute": attribute]
        } else {
            data = ["id": id, "name": name]
        }
        
        self.init(dictionary: data)
        
    }
    
    public func dictionaryValue() -> [String : Any] {
        guard let attribute = attribute else {
            return [
                "id": id,
                "name": name
            ]
        }
        
        return [
            "id": id,
            "name": name,
            "attribute": attribute
        ]
    }
}
