//
//  CDContentSticker.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/23/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import PrismCore

class CDContentSticker: ValueTransformer, NSCoding, CDMappable {
    var sticker: CDMessageSticker
    
    required init?(dictionary: [String : Any]) {
        sticker = CDMessageSticker(dictionary: dictionary["sticker"] as! [String: Any])!
    }
    
    public func dictionaryValue() -> [String : Any] {
        return ["sticker": sticker.dictionaryValue()]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(sticker, forKey: "sticker")
    }
    
    required init?(coder aDecoder: NSCoder) {
        sticker = aDecoder.decodeObject(forKey: "sticker") as! CDMessageSticker
    }
}

class CDMessageSticker: NSObject, NSCoding, CDMappable {
    var name: String
    var imageURL: URL
    var id: String
    var packID: String
    
    required init?(dictionary: [String : Any]) {
        name = dictionary["name"] as! String
        imageURL = URL(string: dictionary["image_url"] as! String)!
        id = dictionary["id"] as! String
        packID = dictionary["pack_id"] as! String
    }
    
    public func dictionaryValue() -> [String : Any] {
        return ["name": name,
                "image_url": imageURL.absoluteString,
                "id": id,
                "pack_id": packID]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(imageURL, forKey: "image_url")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(packID, forKey: "pack_id")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        imageURL = aDecoder.decodeObject(forKey: "image_url") as! URL
        id = aDecoder.decodeObject(forKey: "id") as! String
        packID = aDecoder.decodeObject(forKey: "pack_id") as! String
    }
}
