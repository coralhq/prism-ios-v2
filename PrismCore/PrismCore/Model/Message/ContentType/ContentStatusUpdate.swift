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
    
    required init?(json: [String : Any]?) {
        guard let statusUpdate = StatusUpdate(json: json?["message_status_update"] as? [String: Any]) else {
            return nil
        }
        
        self.statusUpdate = statusUpdate
    }
}

class StatusUpdate: Mappable {
    let id: String
    let status: String
    
    required init?(json: [String : Any]?) {
        guard let id = json?["message_id"] as? String,
        let status = json?["message_status"] as? String else {
            return nil
        }
        
        self.id = id
        self.status = status
    }
}
