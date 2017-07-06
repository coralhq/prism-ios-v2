//
//  ContentOfflineMessage.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

public class ContentOfflineMessage: MessageContentMappable {
    public let name: String
    public let email: String
    public let phone: String
    public let text: String
    
    var dictionary: [String: Any]?
    
    required public init?(dictionary: [String : Any]?) {
        guard let offlineMessage = dictionary?["offline_message"] as? [String: Any],
            let name = offlineMessage["name"] as? String,
            let email = offlineMessage["email"] as? String,
            let text = offlineMessage["text"] as? String,
            let phone = offlineMessage["phone"] as? String else {
                return nil
        }
        
        self.dictionary = dictionary
        
        self.name = name
        self.email = email
        self.text = text
        self.phone = phone
    }
    
    convenience public init?(name: String, email: String, phone: String, text: String) {
        self.init(dictionary: [
            "offline_message": [
                "name": name,
                "email": email,
                "phone": phone,
                "text": text
                ]
            ]
        )
    }
    
    public func dictionaryValue() -> [String : Any]? {
        return dictionary
    }
}
