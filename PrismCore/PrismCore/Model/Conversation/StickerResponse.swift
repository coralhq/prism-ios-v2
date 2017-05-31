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
    
    required public init?(json: [String : Any]?) {
        guard let data = json?["data"] as? [String: Any],
            let status = json?["status"] as? String,
            let packsJson = data["packs"] as? [[String: Any]] else {
                return nil
        }
        
        var packs: [StickerPack] = []
        for json in packsJson {
            guard let pack = StickerPack(json: json) else {
                return nil
            }
            
            packs.append(pack)
        }
        
        self.status = status
        self.packs = packs
    }
}
