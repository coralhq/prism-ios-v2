//
//  Conversation.swift
//  PrismCoreSDK
//
//  Created by fanni suyuti on 5/19/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

//TODO: some properties might unused, re-check later
public class Conversation : Mappable {
    
    public let createdAt: Date // "2017-05-19T03:39:31.814Z"
    public let updatedAt: Date
    public let id: String
    public let topic: String
    public let status: String
    public let merchantID: String
    public let hasContent: Bool
    public let channel: String
    public let channelInfo: String?
    public let visitor: ConversationVisitor
    public let participants: [ConversationParticipant]
    public let assignee: String?
    public let assigmentHistories: [ConversationHistory]
    public let tags: [String]?
    public let latestMessagePayload: String?
    
    required public init?(json: [String: Any]?) {
        
        guard let createdAt = Date.getDateFromISO8601(string: json?["created_at"] as? String),
            let updatedAt = Date.getDateFromISO8601(string: json?["updated_at"] as? String),
            let id = json?["id"] as? String,
            let topic = json?["topic"] as? String,
            let status = json?["status"] as? String,
            let merchantID = json?["merchant_id"] as? String,
            let hasContent = json?["has_content"] as? Bool,
            let channel = json?["channel"] as? String,
            let visitor = ConversationVisitor(json: json?["visitor"] as? [String: Any]),
            let jsonParticipants = json?["participants"] as? [[String: Any]]
            else {
                return nil
        }
        
        channelInfo = json?["channel_info"] as? String
        assignee = json?["assignee"] as? String
        latestMessagePayload = json?["latest_msg_payload"] as? String
        assigmentHistories = []
        tags = json?["tags"] as? [String]
        
        var participants: [ConversationParticipant] = []
        
        for json in jsonParticipants {
            guard let participant = ConversationParticipant(json: json) else {
                return nil
            }
            
            participants.append(participant)
        }
        
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.id = id
        self.topic = topic
        self.status = status
        self.merchantID = merchantID
        self.hasContent = hasContent
        self.channel = channel
        self.visitor = visitor
        self.participants = participants
    }
}
