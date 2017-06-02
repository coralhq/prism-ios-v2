//
//  Sticker.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/22/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

//TODO: create correct date parser
class Sticker: Mappable {
    let createdAt: Date
    let updatedAt: Date
    let id: String
    let name: String
    let imageURL: URL
    let packID: String
    
    required init?(dictionary: [String : Any]?) {
        guard let createdAtString = dictionary?["created_at"] as? String,
            let createdAt = createdAtString.ISO8601Date,
            let updatedAtString = dictionary?["updated_at"] as? String,
            let updatedAt = updatedAtString.ISO8601Date,
            let id = dictionary?["id"] as? String,
            let name = dictionary?["name"] as? String,
            let imageURL = dictionary?["image_url"] as? URL,
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
}
