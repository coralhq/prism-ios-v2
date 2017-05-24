//
//  getAttachmentURL.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/23/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

class GetAttachmentURLEndPoint: EndPoint {
    
    let filename: String
    let conversationID: String
    var url: URL {
        get {
            return URL.getAttachmentURL(conversationID: conversationID)
        }
    }
    var method = HTTPMethod.POST
    var token: String?
    var httpBody: [String : Any] {
        get {
            return [
                "filename": filename
            ]
        }
    }
    var contentType: String? {
        get {
            return "application/json"
        }
    }
    
    init(filename: String, conversationID: String, token: String) {
        self.filename = filename
        self.token = token
        self.conversationID = conversationID
    }
}
