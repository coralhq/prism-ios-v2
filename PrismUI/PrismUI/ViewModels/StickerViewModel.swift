//
//  StickerViewModel.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/22/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import PrismCore

class StickerViewModel: NSObject, NSCoding {
    var name: String
    var imageURL: URL
    var packID: String
    var id: String
    
    init(sticker: Sticker) {
        self.name = sticker.name
        self.imageURL = sticker.imageURL
        self.packID = sticker.packID
        self.id = sticker.id
    }

    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(imageURL, forKey: "image_url")
        aCoder.encode(packID, forKey: "pack_id")
        aCoder.encode(id, forKey: "id")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        imageURL = aDecoder.decodeObject(forKey: "image_url") as! URL
        packID = aDecoder.decodeObject(forKey: "pack_id") as! String
        id = aDecoder.decodeObject(forKey: "id") as! String
    }
}
