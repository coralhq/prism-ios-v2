//
//  ContentCloseChat.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

class ContentCloseChat: MessageContentMappable {
    
    let closedBy: MessageUser
    let message: ContentPlainText
    
    required init?(json: [String : Any]?) {
        guard let closeChat = json?["close_chat"] as? [String: Any],
            let closedBy = MessageUser(json: closeChat["closed_by"] as? [String : Any]),
            let message = ContentPlainText(json: closeChat["message"] as? [String : Any]) else {
            return nil
        }
        
        self.closedBy = closedBy
        self.message = message
    }
}
