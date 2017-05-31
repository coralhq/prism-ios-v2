//
//  StickerResponse.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/22/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

open class StickerResponse: Mappable {
    
    let status: String
    let packs: [StickerPack]
    
    required public init?(dictionary: [String : Any]?) {
        guard let data = dictionary?["data"] as? [String: Any],
            let status = dictionary?["status"] as? String,
            let packDictionaries = data["packs"] as? [[String: Any]]
            else {
                return nil
        }
        
        var packs: [StickerPack] = []
        for dictionary in packDictionaries {
            guard let pack = StickerPack(dictionary: dictionary) else {
                return nil
            }
            
            packs.append(pack)
        }
        
        self.status = status
        self.packs = packs
    }
}
