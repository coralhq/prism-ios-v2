//
//  ConversationVisitor.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/22/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

//TODO: some properties might unused, re-check later
open class ConversationVisitor: NSObject, Mappable {
    
    public let createdAt: Date //"2017-05-19T03:39:31.808Z"
    public let updatedAt: Date
    public let id: String
    public let name: String
    public let avatar: String
    public let merchantID: String
    
    required public init?(dictionary: [String: Any]?) {
        guard let createdAtString = dictionary?["created_at"] as? String,
            let createdAt = createdAtString.ISO8601Date,
            let updatedAtString = dictionary?["updated_at"] as? String,
            let updatedAt = updatedAtString.ISO8601Date,
            let id = dictionary?["id"] as? String,
            let merchantID = dictionary?["merchant_id"] as? String,
            let avatar = dictionary?["avatar"] as? String,
            let name = dictionary?["name"] as? String
            
            else {
                return nil
        }
        
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.id = id
        self.avatar = avatar
        self.name = name
        self.merchantID = merchantID
    }
    
    public func dictionaryValue() -> [String : Any] {
        return ["created_at": createdAt.ISO8601String,
                "updated_at": updatedAt.ISO8601String,
                "id": id,
                "merchant_id": merchantID,
                "avatar": avatar,
                "name": name]
    }
}
