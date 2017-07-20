//
//  CreateConversationEndPoint.swift
//  PrismCoreSDK
//
//  Created by fanni suyuti on 5/19/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

class CreateConversationEndPoint : EndPoint {
    
    var url = URL.createConversation
    var method = HTTPMethod.POST
    var token: String?
    var visitorName: String
    var httpBody: [String : Any] {
        get {
            return [
                "channel": "IOS_SDK",
                "visitor": [
                    "name": visitorName,
                    "avatar_url": ""
                ]
            ]
        }
    }
    var contentType: String? {
        get {
            return "application/json"
        }
    }
    
    init(visitorName: String, token: String) {
        self.token = token
        self.visitorName = visitorName
    }
}
