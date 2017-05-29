//
//  ContentSticker.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

class ContentSticker: MessageContentMappable {
    let sticker: MessageSticker
    
    required init?(json: [String : Any]?) {
        guard let sticker = MessageSticker(json: json?["sticker"] as? [String: Any]) else {
            return nil
        }
        
        self.sticker = sticker
    }
}

class MessageSticker: Mappable {
    
    let name: String
    let imageURL: URL
    let id: String
    let packID: String
    
    required init?(json: [String : Any]?) {
        guard let name = json?["name"] as? String,
        let url = json?["image_url"] as? String,
        let imageURL = URL(string: url),
        let id = json?["id"] as? String,
        let packID = json?["pack_id"] as? String else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.packID = packID
    }
}
