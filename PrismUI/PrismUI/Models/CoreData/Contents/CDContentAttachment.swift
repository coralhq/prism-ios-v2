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

class CDContentAttachment: ValueTransformer, NSCoding, CDMappable, CDContentEditable{
    var name: String
    var mimeType: String
    var url: String?
    var previewURL: String?
    var uploadState: AttachmentUploadState = .finished
    
    required init?(dictionary: [String : Any]) {
        let attachment = dictionary["attachment"] as! [String: Any]
        name = attachment["name"] as! String
        mimeType = attachment["mimetype"] as! String
        url = attachment["url"] as? String
        previewURL = attachment["preview_url"] as? String
    }
    
    func dictionaryValue() -> [String : Any] {
        var result: [String: Any] = ["name": name,
                                     "mimetype": mimeType]
        if let url = url {
            result["url"] = url
        }
        if let previewURL = previewURL {
            result["preview_url"] = previewURL
        }
        return result
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(mimeType, forKey: "mime_type")
        aCoder.encode(url, forKey: "url")
        aCoder.encode(previewURL, forKey: "preview_url")
        aCoder.encode(uploadState.rawValue, forKey: "upload_state")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        mimeType = aDecoder.decodeObject(forKey: "mime_type") as! String
        url = aDecoder.decodeObject(forKey: "url") as? String
        previewURL = aDecoder.decodeObject(forKey: "preview_url") as? String

        guard let state = aDecoder.decodeObject(forKey: "upload_state") as? Int else {
            return
        }
        self.uploadState = AttachmentUploadState(rawValue: state)!
    }
    
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
