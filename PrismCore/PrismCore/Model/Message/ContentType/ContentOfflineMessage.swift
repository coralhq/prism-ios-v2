//
//  ContentOfflineMessage.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

open class ContentOfflineMessage: MessageContentMappable {
    public let name: String?
    public let email: String?
    public let phone: String?
    public let text: String
    
    required public init?(dictionary: [String : Any]?) {
        guard let offlineMessage = dictionary?["offline_message"] as? [String: Any],
            let text = offlineMessage["text"] as? String else {
                return nil
        }
        
        self.name = offlineMessage["name"] as? String
        self.email = offlineMessage["email"] as? String
        self.phone = offlineMessage["phone"] as? String
        self.text = text
    }
    
    convenience public init?(name: String?, email: String?, phone: String?, text: String) {
        var forms = ["text": text]
        if let name = name {
            forms["name"] = name
        }
        if let email = email {
            forms["email"] = email
        }
        if let phone = phone {
            forms["phone"] = phone
        }
        self.init(dictionary: ["offline_message": forms])
    }
    
    public func dictionaryValue() -> [String : Any] {
        var forms = ["text": text]
        if let name = self.name {
            forms["name"] = name
        }
        if let email = self.email {
            forms["email"] = email
        }
        if let phone = self.phone {
            forms["phone"] = phone
        }
        return ["offline_message": forms]
    }
}
