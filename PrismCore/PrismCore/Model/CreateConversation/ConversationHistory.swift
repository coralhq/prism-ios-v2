//
//  ConversationHistory.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/22/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

open class ConversationHistory: Mappable {
    public let messages: [Message]
    
    required public init?(dictionary: [String : Any]?) {
        guard let data = dictionary?["data"] as? [String: Any],
            let messageDictionaries = data["messages"] as? [[String: Any]]
            else { return nil }
        
        var messages: [Message] = []
        for dictionary in messageDictionaries {
            guard let payload = dictionary["payload"] as? [String: Any],
                let message = Message(dictionary: payload) else {
                continue
            }
            
            messages.append(message)
        }
        
        self.messages = messages
    }
    
    public func dictionaryValue() -> [String : Any] {
        var messages: [[String: Any]] = []
        for message in self.messages {
            messages.append(message.dictionaryValue())
        }
        return ["data": ["messages": messages]]
    }
}
