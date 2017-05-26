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
    
    required public init?(json: [String : Any]?) {
        guard let data = json?["data"] as? [String: Any],
            let jsonMessages = data["messages"] as? [[String: Any]]
            else { return nil }
        
        var messages: [Message] = []
        for json in jsonMessages {
            guard let message = Message(json: json) else {
                return nil
            }
            
            messages.append(message)
        }
        
        self.messages = messages
    }
}
