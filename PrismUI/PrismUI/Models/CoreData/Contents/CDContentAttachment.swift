//
//  CDContentAttachment.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/23/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import PrismCore

class CDContentAttachment: ValueTransformer, NSCoding {
    var name: String?
    var mimeType: String?
    var url: URL?
    var previewURL: URL?
    
    init(contentAttachment: ContentAttachment) {
        name = contentAttachment.name
        mimeType = contentAttachment.mimeType
        url = contentAttachment.url
        previewURL = contentAttachment.previewURL
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(mimeType, forKey: "mime_type")
        aCoder.encode(url, forKey: "url")
        aCoder.encode(previewURL, forKey: "preview_url")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String
        mimeType = aDecoder.decodeObject(forKey: "mime_type") as? String
        url = aDecoder.decodeObject(forKey: "url") as? URL
        previewURL = aDecoder.decodeObject(forKey: "preview_url") as? URL
    }
}
