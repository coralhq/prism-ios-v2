//
//  CDContentAttachment.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/23/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import PrismCore

enum AttachmentUploadState: Int {
    case start = 11
    case uploading = 22
    case finished = 33
}

class CDContentAttachment: ValueTransformer, NSCoding {
    var name: String?
    var mimeType: String?
    var url: String?
    var previewURL: String?
    var uploadState: AttachmentUploadState?
    
    init(contentAttachment: ContentAttachment) {
        name = contentAttachment.name
        mimeType = contentAttachment.mimeType
        url = contentAttachment.url
        previewURL = contentAttachment.previewURL
        
        uploadState = .finished
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(mimeType, forKey: "mime_type")
        aCoder.encode(url, forKey: "url")
        aCoder.encode(previewURL, forKey: "preview_url")
        aCoder.encode(uploadState?.rawValue, forKey: "upload_state")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String
        mimeType = aDecoder.decodeObject(forKey: "mime_type") as? String
        url = aDecoder.decodeObject(forKey: "url") as? String
        previewURL = aDecoder.decodeObject(forKey: "preview_url") as? String
        
        guard let state = aDecoder.decodeObject(forKey: "upload_state") as? Int else { return }
        self.uploadState = AttachmentUploadState(rawValue: state)
    }
}

extension CDContentAttachment: CDContentEditable {
    func editWithContent(content: MessageContentMappable) {
        guard let content = content as? ContentAttachment else {
            return
        }
        name = content.name
        mimeType = content.mimeType
        url = content.url
        previewURL = content.previewURL
    }
}

protocol CDContentEditable {
    func editWithContent(content: MessageContentMappable)
}
