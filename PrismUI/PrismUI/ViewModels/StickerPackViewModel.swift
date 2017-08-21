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
    
    static func getStickers(completion:(() -> ())?) {
        guard let token = Vendor.shared.credential?.accessToken else {
            return
        }
        PrismCore.shared.getStickers(token: token) { (response, error) in
            guard let response = response else {
                return
            }
            
            var packs: [StickerPackViewModel] = []
            for pack in response.packs {
                packs.append(StickerPackViewModel(pack: pack))
            }
            
            Utils.archive(object: packs, key: "prism_sticker_packs")
            
            completion?()
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
