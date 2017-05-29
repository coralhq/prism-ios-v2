//
//  ContentOfflineMessage.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

class ContentOfflineMessage: MessageContentMappable {
    let name: String
    let email: String
    let phone: String
    let text: String
    
    required init?(json: [String : Any]?) {
        guard let offlineMessage = json?["offline_message"] as? [String: Any],
            let name = offlineMessage["name"] as? String,
            let email = offlineMessage["email"] as? String,
            let text = offlineMessage["text"] as? String,
            let phone = offlineMessage["phone"] as? String else {
                return nil
        }
        
        self.name = name
        self.email = email
        self.text = text
        self.phone = phone
    }
}
