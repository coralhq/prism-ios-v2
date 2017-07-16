//
//  StickerViewModel.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 7/5/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation

class ContentStickerViewModel: ContentViewModel {
    let stickerURL: URL?
    
    init(contentSticker: CDContentSticker) {
        stickerURL = contentSticker.sticker.imageURL
    }
}
