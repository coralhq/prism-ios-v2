//
//  GetConversationHistory.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/23/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

class GetConversationHistoryEndPoint: EndPoint {
    
    let conversationID: String
    let startTime: Int64
    let endTime: Int64
    
    var url: URL {
        get {
            return URL.getConversationHistory(conversationID: conversationID, startTime: startTime, endTime: endTime)
        }
    }
    var method = HTTPMethod.GET
    var token: String?
    var httpBody: [String : Any] {
        get {
            return [:]
        }
    }
    var contentType: String? {
        get {
            return "application/json"
        }
    }
    
    init(conversationID: String, token: String, startTime: Int64, endTime: Int64) {
        self.conversationID = conversationID
        self.token = token
        self.startTime = startTime
        self.endTime = endTime
    }
}
