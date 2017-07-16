//
//  ConversationParticipant.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/22/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

//TODO: some properties might unused, re-check later
public class ConversationParticipant: Mappable {
    let createdAt: Date //"2017-05-19T03:39:31.808Z"
    let updatedAt: Date
    let id: String
    let userID: String
    let role: String
    let conversationID: String
    let isRead: Bool
    
    required public init?(dictionary: [String: Any]?) {
        guard let createdAtString = dictionary?["created_at"] as? String,
            let createdAt = createdAtString.ISO8601Date,
            let updatedAtString = dictionary?["updated_at"] as? String,
            let updatedAt = updatedAtString.ISO8601Date,
            let id = dictionary?["id"] as? String,
            let userID = dictionary?["user_id"] as? String,
            let role = dictionary?["role"] as? String,
            let conversationID = dictionary?["conversation_id"] as? String,
            let isRead = dictionary?["is_read"] as? Bool
            else {
                return nil
        }
        
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.id = id
        self.userID = userID
        self.role = role
        self.conversationID = conversationID
        self.isRead = isRead
    }
    
    public func dictionaryValue() -> [String : Any] {
        return ["created_at": createdAt.ISO8601String,
                "updated_at": updatedAt.ISO8601String,
                "id": id,
                "user_id": userID,
                "role": role,
                "conversation_id": conversationID,
                "is_read": isRead]
    }
}
