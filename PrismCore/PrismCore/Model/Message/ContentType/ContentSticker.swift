//
//  ContentSticker.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

public class ContentSticker: MessageContentMappable {
    
    let sticker: MessageSticker
    
    public var dictionaryValue: [String: Any] {
        get {
            return [
                "sticker": [
                    "name": sticker.name,
                    "image_url": sticker.imageURL.absoluteString,
                    "id": sticker.id,
                    "pack_id": sticker.packID
                ]
            ]
        }
    }
    
    required public init?(dictionary: [String : Any]?) {
        guard let sticker = MessageSticker(dictionary: dictionary?["sticker"] as? [String: Any]) else {
            return nil
        }
        
        self.sticker = sticker
    }
    
    convenience public init?(name: String, imageURL: String, id: String, packID: String) {
        self.init(dictionary: [
            "sticker": [
                "name": name,
                "image_url": imageURL,
                "id": id,
                "pack_id": packID
            ]
            ]
        )
    }
}

class MessageSticker: Mappable {
    
    let name: String
    let imageURL: URL
    let id: String
    let packID: String
    
    required init?(dictionary: [String : Any]?) {
        guard let name = dictionary?["name"] as? String,
        let url = dictionary?["image_url"] as? String,
        let imageURL = URL(string: url),
        let id = dictionary?["id"] as? String,
        let packID = dictionary?["pack_id"] as? String else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.packID = packID
    }
}
