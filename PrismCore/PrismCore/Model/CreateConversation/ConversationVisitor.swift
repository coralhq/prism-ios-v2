//
//  ConversationVisitor.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/22/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

//TODO: some properties might unused, re-check later
public class ConversationVisitor {
    
    public let createdAt: Date //"2017-05-19T03:39:31.808Z"
    public let updatedAt: Date
    public let id: String
    public let name: String
    public let avatar: String
    public let merchantID: String
    
    required public init?(json: [String: Any]?) {
        guard let createdAt = Date.getDateFromISO8601(string: json?["created_at"] as? String),
            let updatedAt = Date.getDateFromISO8601(string: json?["updated_at"] as? String),
            let id = json?["id"] as? String,
            let merchantID = json?["merchant_id"] as? String,
            let avatar = json?["avatar"] as? String,
            let name = json?["name"] as? String
            
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
}
