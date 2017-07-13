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
    open var invalid: [Message]
    
    public required init?(dictionary: [String: Any]?) {
        guard let data = dictionary?["data"] as? [String: Any],
            let failed = data["failed"] as? [[String: Any]],
            let invalid = data["invalid"] as? [[String: Any]] else {
                return nil
        }
        
        var failedMessages: [Message] = []
        for message in failed {
            guard let failedMessage = Message(dictionary: message) else {
                return nil
            }
            
            failedMessages.append(failedMessage)
        }
        
        var invalidMessages: [Message] = []
        for message in invalid {
            guard let invalidMessage = Message(dictionary: message) else {
                return nil
            }
            
            invalidMessages.append(invalidMessage)
        }
        
        self.failed = failedMessages
        self.invalid = invalidMessages
    }
}
