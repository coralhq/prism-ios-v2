//
//  ContentStatusUpdate.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

class ContentStatusUpdate: MessageContentMappable {
    let statusUpdate: StatusUpdate
    
    required init?(dictionary: [String : Any]?) {
        guard let statusUpdate = StatusUpdate(dictionary: dictionary?["message_status_update"] as? [String: Any]) else {
            return nil
        }
        self.statusUpdate = statusUpdate
    }
    
    func dictionaryValue() -> [String : Any] {
        return ["message_status_update": statusUpdate.dictionaryValue()]
    }
}

class StatusUpdate: Mappable {
    let id: String
    let status: String
    
    required init?(dictionary: [String : Any]?) {
        guard let id = dictionary?["message_id"] as? String,
            let status = dictionary?["message_status"] as? String else {
                return nil
        }
        
        self.id = id
        self.status = status
    }
    
    func dictionaryValue() -> [String : Any] {
        return ["message_id": id,
                "message_status": status]
    }
}
