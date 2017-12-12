//
//  CreateConversationResponse.swift
//  PrismCoreSDK
//
//  Created by fanni suyuti on 5/19/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

//TODO: some properties might unused, re-check later
open class CreateConversationResponse : NSObject, Mappable {
    
    let status: String
    public let conversation: Conversation
    
    required public init?(dictionary: [String: Any]?) {
        guard let status = dictionary?["status"] as? String,
            let data = dictionary?["data"] as? [String: Any],
            let conversation = Conversation(dictionary: data["conversation"] as? [String: Any])
            else {
                return nil
        }
        
        self.status = status
        self.conversation = conversation
    }
    
    public func dictionaryValue() -> [String : Any] {
        return ["status": status,
                "data": ["conversation": conversation.dictionaryValue()]]
    }
}

