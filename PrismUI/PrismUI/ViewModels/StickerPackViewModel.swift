//
//  StickerPackViewModel.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/22/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import PrismCore

class StickerPackViewModel: NSObject, NSCoding {
    var name: String
    var imageURL: URL
    var stickers: [StickerViewModel]
    
    init(pack: StickerPack) {
        self.name = pack.name
        self.imageURL = pack.logoURL
        
        var stickers: [StickerViewModel] = []
        for sticker in pack.stickers {
            stickers.append(StickerViewModel(sticker: sticker))
        }
        self.stickers = stickers
    }
    
    static func getStickers(accessToken: String, completion:@escaping (_ stickerPacks: [StickerPackViewModel]?) -> ()) {
        PrismCore.shared.getStickers(token: accessToken) { (response, error) in
            guard let response = response else {
                completion(nil)
                return
            }
            
            var result: [StickerPackViewModel] = []
            for pack in response.packs {
                result.append(StickerPackViewModel(pack: pack))
            }
            completion(result)
        }
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(stickers, forKey: "stickers")
        aCoder.encode(imageURL, forKey: "image_url")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        stickers = aDecoder.decodeObject(forKey: "stickers") as! [StickerViewModel]
        imageURL = aDecoder.decodeObject(forKey: "image_url") as! URL
    }
}
