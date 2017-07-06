//
//  ContentImageViewModel.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 7/6/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation

class ContentImageViewModel: ContentViewModel {
    var imageURL: URL
    
    init?(contentImage: CDContentAttachment) {
        guard let imageURL = contentImage.url else { return nil }
        self.imageURL = imageURL
    }
}
