//
//  SendTokenResponse.swift
//  PrismCore
//
//  Created by fanni suyuti on 8/8/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

class SendTokenResponse: Mappable {
    let id: String
    let token: String
    
    required init?(dictionary: [String: Any]?) {
        guard let data = dictionary?["data"] as? [String: Any],
            let id = data["id"] as? String,
            let token = data["token"] as? String else {
                return nil
        }
        
        self.token = token
        self.id = id
    }
    
    func dictionaryValue() -> [String: Any] {
        return [
            "id": self.id,
            "token": token,
            "device_type": "iOS"
        ]
    }
}
