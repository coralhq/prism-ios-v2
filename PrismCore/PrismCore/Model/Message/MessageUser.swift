//
//  MessageUser.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

class MessageUser: Mappable {
    let id: String
    let name: String
    
    required init?(json: [String : Any]?) {
        guard let id = json?["id"] as? String,
            let name = json?["name"] as? String else {
                return nil
        }
        
        self.id = id
        self.name = name
    }
}
