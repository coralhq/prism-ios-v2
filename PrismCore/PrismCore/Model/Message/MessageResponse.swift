//
//  MessageResponse.swift
//  PrismCore
//
//  Created by fanni suyuti on 7/7/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

open class MessageResponse: Mappable {
    open var failed: [Message]
    open var skipped: [Message]
    
    public required init?(dictionary: [String: Any]?) {
        guard let data = dictionary?["data"] as? [String: Any],
            let failed = data["failed"] as? [[String: Any]],
            let skipped = data["skipped"] as? [[String: Any]] else {
                return nil
        }
        
        var failedMessages: [Message] = []
        for message in failed {
            guard let failedMessage = Message(dictionary: message) else {
                return nil
            }
            
            failedMessages.append(failedMessage)
        }
        
        var skippedMessages: [Message] = []
        for message in skipped {
            guard let skippedMessage = Message(dictionary: message) else {
                return nil
            }
            
            skippedMessages.append(skippedMessage)
        }
        
        self.failed = failedMessages
        self.skipped = skippedMessages
    }
}
