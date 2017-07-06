//
//  CDContentSticker.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/23/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import PrismCore

class CDContentSticker: ValueTransformer, NSCoding {
    var sticker: CDMessageSticker?
    
    init(contentSticker: ContentSticker) {
        sticker = CDMessageSticker(sticker: contentSticker.sticker)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(sticker, forKey: "sticker")
    }
    
    required init?(coder aDecoder: NSCoder) {
        sticker = aDecoder.decodeObject(forKey: "sticker") as? CDMessageSticker
    }
}

class CDMessageSticker: NSObject, NSCoding {
    var name: String?
    var imageURL: URL?
    var id: String?
    var packID: String?
    
    init(sticker: MessageSticker) {
        name = sticker.name
        imageURL = sticker.imageURL
        id = sticker.id
        packID = sticker.packID
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(imageURL, forKey: "image_url")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(packID, forKey: "pack_id")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String
        imageURL = aDecoder.decodeObject(forKey: "image_url") as? URL
        id = aDecoder.decodeObject(forKey: "id") as? String
        packID = aDecoder.decodeObject(forKey: "pack_id") as? String
    }
}
