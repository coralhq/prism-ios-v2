//
//  ContentAttachment.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

public class ContentAttachment: MessageContentMappable {
    
    let name: String
    let mimeType: String
    let url: URL
    let previewURL: URL
    
    public var dictionaryValue: [String: Any] {
        get {
            return [
                "attachment": [
                    "name": name,
                    "mimetype": mimeType,
                    "url": url,
                    "preview_url": previewURL
                ]
            ]
        }
    }
    
    required public init?(json: [String: Any]?) {
        guard let attachment = json?["attachment"] as? [String: Any],
        let name = attachment["name"] as? String,
        let mimeType = attachment["mimetype"] as? String,
            let urlString = attachment["url"] as? String,
            let url = URL(string: urlString),
            let previewURLString = attachment["preview_url"] as? String,
            let previewURL = URL(string: previewURLString) else {
                return nil
        }
        
        self.name = name
        self.mimeType = mimeType
        self.url = url
        self.previewURL = previewURL
    }
    
    convenience public init?(name: String, mimeType: String, url: String, previewURL: String) {
        self.init(json: [
            "attachment": [
                "name": name,
                "mimetype": mimeType,
                "url": url,
                "preview_url": previewURL
                ]
            ]
        )
    }
}
