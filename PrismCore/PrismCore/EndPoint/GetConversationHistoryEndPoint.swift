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
    
    var url: URL {
        get {
            return URL.getConversationHistory(conversationID: conversationID)
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
    
    init(conversationID: String, token: String) {
        self.conversationID = conversationID
        self.token = token
    }
}
