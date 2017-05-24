//
//  CreateConversationResponse.swift
//  PrismCoreSDK
//
//  Created by fanni suyuti on 5/19/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

//TODO: some properties might unused, re-check later
open class CreateConversationResponse : Mappable {
    
    let status: String
    public let conversation: Conversation
    
    required public init?(json: [String: Any]?) {
        guard let status = json?["status"] as? String,
            let data = json?["data"] as? [String: Any],
            let conversation = Conversation(json: data["conversation"] as? [String: Any])
            else {
                return nil
        }
        
        self.status = status
        self.conversation = conversation
    }
    
}

