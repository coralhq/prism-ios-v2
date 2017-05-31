//
//  StickerPack.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/22/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

class StickerPack: Mappable {
    let createdAt: Date
    let updatedAt: Date
    let id: String
    let name: String
    let logoURL: URL
    let createdBy: String
    let isPublic: Bool
    let stickers: [Sticker]
    
    required init?(dictionary: [String : Any]?) {
        guard let createdAt = Date.getDateFromISO8601(string: dictionary?["created_at"] as? String),
            let updatedAt = Date.getDateFromISO8601(string: dictionary?["updated_at"] as? String),
            let id = dictionary?["id"] as? String,
            let name = dictionary?["name"] as? String,
            let logoURLString = dictionary?["logo_url"] as? String,
            let logoURL = URL(string: logoURLString),
            let isPublic = dictionary?["is_public"] as? Bool,
            let stickerDictionaries = dictionary?["stickers"] as? [[String: Any]],
            let createdBy = dictionary?["created_by"] as? String
            else {
                return nil
        }
        
        var stickers: [Sticker] = []
        for dictionary in stickerDictionaries {
            guard let sticker = Sticker(dictionary: dictionary) else {
                return nil
            }
            
            stickers.append(sticker)
        }
        
        self.stickers = stickers
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.id = id
        self.name = name
        self.logoURL = logoURL
        self.isPublic = isPublic
        self.createdBy = createdBy
    }
    
}
