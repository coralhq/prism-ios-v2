//
//  Conversation.swift
//  PrismCoreSDK
//
//  Created by fanni suyuti on 5/19/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

//TODO: some properties might unused, re-check later
open class Conversation : NSObject, Mappable {
    
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
        
        guard let createdAtString = dictionary?["created_at"] as? String,
            let createdAt = createdAtString.ISO8601Date,
            let updatedAtString = dictionary?["updated_at"] as? String,
            let updatedAt = updatedAtString.ISO8601Date,
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
    
    public func dictionaryValue() -> [String : Any] {
        let participants = self.participants.map { (participant) -> [String: Any] in
            return participant.dictionaryValue()
        }
        var result: [String: Any] = ["created_at": createdAt.ISO8601String,
                                     "updated_at": updatedAt.ISO8601String,
                                     "id": id,
                                     "topic": topic,
                                     "status": status,
                                     "merchant_id": merchantID,
                                     "has_content": hasContent,
                                     "channel": channel,
                                     "participants": participants]
        if let info = channelInfo {
            result["channel_info"] = info
        }
        if let assignee = assignee {
            result["assignee"] = assignee
        }
        if let payload = latestMessagePayload {
            result["latest_msg_payload"] = payload
        }
        if let tags = tags {
            result["tags"] = tags
        }
        if let visitor = visitor {
            result["visitor"] = visitor.dictionaryValue()
        }        
        return result
    }
}
