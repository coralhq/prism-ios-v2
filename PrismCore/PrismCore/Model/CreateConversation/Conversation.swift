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
    public let visitor: ConversationVisitor?
    public let participants: [ConversationParticipant]
    public let assignee: String?
    public let assigmentHistories: [ConversationHistory]?
    public let tags: [String]?
    public let latestMessagePayload: String?
    
    required public init?(dictionary: [String: Any]?) {
        
        guard let createdAt = Date.getDateFromISO8601(string: dictionary?["created_at"] as? String),
            let updatedAt = Date.getDateFromISO8601(string: dictionary?["updated_at"] as? String),
            let id = dictionary?["id"] as? String,
            let topic = dictionary?["topic"] as? String,
            let status = dictionary?["status"] as? String,
            let merchantID = dictionary?["merchant_id"] as? String,
            let hasContent = dictionary?["has_content"] as? Bool,
            let channel = dictionary?["channel"] as? String
            else {
                return nil
        }
        
        channelInfo = dictionary?["channel_info"] as? String
        assignee = dictionary?["assignee"] as? String
        latestMessagePayload = dictionary?["latest_msg_payload"] as? String
        assigmentHistories = []
        tags = dictionary?["tags"] as? [String]
        visitor = ConversationVisitor(dictionary: dictionary?["visitor"] as? [String: Any])
        
        var participants: [ConversationParticipant] = []
        
        if let participantDictionaries = dictionary?["participants"] as? [[String: Any]] {
            for dictionary in participantDictionaries {
                guard let participant = ConversationParticipant(dictionary: dictionary) else {
                    return nil
                }
                
                participants.append(participant)
            }
        }
        
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.id = id
        self.topic = topic
        self.status = status
        self.merchantID = merchantID
        self.hasContent = hasContent
        self.channel = channel
        self.participants = participants
    }
}
