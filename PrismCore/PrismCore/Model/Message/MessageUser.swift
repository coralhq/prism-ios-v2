//
//  MessageUser.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

public class MessageUser: Mappable {
    let id: String
    let name: String
    
    required public init?(json: [String : Any]?) {
        guard let id = json?["id"] as? String,
            let name = json?["name"] as? String else {
                return nil
        }
        
        self.id = id
        self.name = name
    }
    
    convenience public init?(id: String, name: String) {
        let data = ["id": id, "name": name ]
        self.init(json: data)
    }
}
