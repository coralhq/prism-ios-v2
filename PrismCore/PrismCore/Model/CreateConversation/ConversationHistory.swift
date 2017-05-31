//
//  ConversationHistory.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/22/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

open class ConversationHistory: Mappable {
    let messages: [Message]
    
    required public init?(dictionary: [String : Any]?) {
        guard let data = dictionary?["data"] as? [String: Any],
            let messageDictionaries = data["messages"] as? [[String: Any]]
            else { return nil }
        
        var messages: [Message] = []
        for dictionary in messageDictionaries {
            guard let message = Message(dictionary: dictionary) else {
                return nil
            }
            
            messages.append(message)
        }
        
        self.messages = messages
    }
}
