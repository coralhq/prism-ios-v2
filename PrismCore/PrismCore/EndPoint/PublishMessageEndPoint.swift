//
//  PublishMessageEndPoint.swift
//  PrismCore
//
//  Created by fanni suyuti on 7/6/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

import Foundation

class PublishMessageEndPoint : EndPoint {
    
    let messages: [Message]
    let topic: String
    
    var method = HTTPMethod.POST
    var token: String?
    var url = URL.prismConnect
    var httpBody: [String: Any] {
        get {
            return [:]
        }
    }
    var messagesBody: [[String: Any]] {
        get {
            var result: [[String: Any]] = []
            for message in messages {
                result.append(["topic" : topic,
                               "message" : message.dictionaryValue()])
            }
            
            return result
        }
    }
    var contentType: String? {
        get {
            return "application/json"
        }
    }
    
    init(token: String, messages: [Message], topic: String) {
        self.token = token
        self.topic = topic
        self.messages = messages
    }
}
