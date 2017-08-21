//
//  Sticker.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/22/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

//TODO: create correct date parser
open class Sticker: NSObject, NSCoding, Mappable {
    let createdAt: Date
    let updatedAt: Date
    public let id: String
    public let name: String
    public let imageURL: URL
    public let packID: String
    
    public required init?(dictionary: [String : Any]?) {
        guard let createdAtString = dictionary?["created_at"] as? String,
            let createdAt = createdAtString.ISO8601Date,
            let updatedAtString = dictionary?["updated_at"] as? String,
            let updatedAt = updatedAtString.ISO8601Date,
            let id = dictionary?["id"] as? String,
            let name = dictionary?["name"] as? String,
            let imageURLString = dictionary?["image_url"] as? String,
            let imageURL = URL(string: imageURLString),
            let packID = dictionary?["pack_id"] as? String
            else {
                return nil
        }
        
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.packID = packID
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(createdAt, forKey: "created_at")
        aCoder.encode(updatedAt, forKey: "updated_at")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(imageURL, forKey: "image_url")
        aCoder.encode(packID, forKey: "pack_id")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        createdAt = aDecoder.decodeObject(forKey: "created_at") as! Date
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as! Date
        id = aDecoder.decodeObject(forKey: "id") as! String
        name = aDecoder.decodeObject(forKey: "name") as! String
        imageURL = aDecoder.decodeObject(forKey: "image_url") as! URL
        packID = aDecoder.decodeObject(forKey: "pack_id") as! String
    }
    
    public func dictionaryValue() -> [String : Any] {
        return ["created_at": createdAt.ISO8601String,
                "updated_at": updatedAt.ISO8601String,
                "id": id,
                "name": name,
                "image_url": imageURL.absoluteString,
                "pack_id": packID]
    }
}
