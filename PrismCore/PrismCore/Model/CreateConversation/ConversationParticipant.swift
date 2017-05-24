//
//  ConversationParticipant.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/22/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

//TODO: some properties might unused, re-check later
public class ConversationParticipant {
    let createdAt: Date //"2017-05-19T03:39:31.808Z"
    let updatedAt: Date
    let id: String
    let userID: String
    let role: String
    let conversationID: String
    let isRead: Bool
    
    required public init?(json: [String: Any]?) {
        guard let createdAt = Date.getDateFromISO8601(string: json?["created_at"] as? String),
            let updatedAt = Date.getDateFromISO8601(string: json?["updated_at"] as? String),
            let id = json?["id"] as? String,
            let userID = json?["user_id"] as? String,
            let role = json?["role"] as? String,
            let conversationID = json?["conversation_id"] as? String,
            let isRead = json?["is_read"] as? Bool
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
}
