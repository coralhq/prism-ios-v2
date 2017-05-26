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
    
    required init?(json: [String : Any]?) {
        guard let createdAt = Date.getDateFromISO8601(string: json?["created_at"] as? String),
            let updatedAt = Date.getDateFromISO8601(string: json?["updated_at"] as? String),
            let id = json?["id"] as? String,
            let name = json?["name"] as? String,
            let logoURL = json?["logo_url"] as? URL,
            let isPublic = json?["is_public"] as? Bool,
            let stickersJson = json?["stickers"] as? [[String: Any]],
            let createdBy = json?["created_by"] as? String
            else {
                return nil
        }
        
        var stickers: [Sticker] = []
        for json in stickersJson {
            guard let sticker = Sticker(json: json) else {
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
