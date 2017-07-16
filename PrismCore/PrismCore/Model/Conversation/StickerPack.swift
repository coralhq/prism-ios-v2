//
//  StickerPack.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/22/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

open class StickerPack: NSObject, NSCoding, Mappable {
    let createdAt: Date
    let updatedAt: Date
    let id: String
    let createdBy: String
    let isPublic: Bool
    public let name: String
    public let logoURL: URL
    public let stickers: [Sticker]
    
    public required init?(dictionary: [String : Any]?) {
        guard let createdAtString = dictionary?["created_at"] as? String,
            let createdAt = createdAtString.ISO8601Date,
            let updatedAtString = dictionary?["updated_at"] as? String,
            let updatedAt = updatedAtString.ISO8601Date,
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
    
    public func dictionaryValue() -> [String : Any] {
        let rawStickers = self.stickers.map { (sticker) -> [String: Any] in
            return sticker.dictionaryValue()
        }        
        return ["created_at": createdAt.ISO8601String,
                "updated_at": updatedAt.ISO8601String,
                "id": id,
                "name": name,
                "logo_url": logoURL.absoluteString,
                "is_public": isPublic,
                "stickers": rawStickers,
                "created_by": createdBy]
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(stickers, forKey: "stickers")
        aCoder.encode(createdAt, forKey: "created_at")
        aCoder.encode(updatedAt, forKey: "updated_at")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(logoURL, forKey: "logo_url")
        aCoder.encode(isPublic, forKey: "is_public")
        aCoder.encode(createdBy, forKey: "created_by")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        stickers = aDecoder.decodeObject(forKey: "stickers") as! [Sticker]
        createdAt = aDecoder.decodeObject(forKey: "created_at") as! Date
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as! Date
        id = aDecoder.decodeObject(forKey: "id") as! String
        name = aDecoder.decodeObject(forKey: "name") as! String
        logoURL = aDecoder.decodeObject(forKey: "logo_url") as! URL
        createdBy = aDecoder.decodeObject(forKey: "created_by") as! String
        isPublic = aDecoder.decodeObject(forKey: "is_public") as! Bool
    }
}
