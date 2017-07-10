//
//  ContentImageViewModel.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 7/6/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import PrismCore

class ContentImageViewModel: ContentViewModel {
    var imageURL: URL?
    var uploadState: AttachmentUploadState?
    var tempImage: UIImage?
    
    init?(contentImage: CDContentAttachment) {
        if let stringURL = contentImage.url {
            self.imageURL = URL(string: stringURL)
        }
        self.uploadState = contentImage.uploadState
        self.tempImage = contentImage.tempAttachment as? UIImage
    }
}
