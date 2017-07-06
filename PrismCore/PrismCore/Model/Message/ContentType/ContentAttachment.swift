//
//  ContentAttachment.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

public class ContentAttachment: MessageContentMappable {
    
    public let name: String
    public let mimeType: String
    public let url: URL
    public var previewURL: URL? = nil
    var dictionary: [String : Any]?
    
    required public init?(dictionary: [String: Any]?) {
        self.dictionary = dictionary
        
        guard let attachment = dictionary?["attachment"] as? [String: Any],
            let name = attachment["name"] as? String,
            let mimeType = attachment["mimetype"] as? String,
            let urlString = attachment["url"] as? String,
            let url = URL(string: urlString) else {
                return nil
        }
        
        if let previewURLString = attachment["preview_url"] as? String {
            previewURL = URL(string: previewURLString)
        }
        
        self.name = name
        self.mimeType = mimeType
        self.url = url
    }
    
    convenience public init?(name: String, mimeType: String, url: String, previewURL: String? = nil) {
        self.init(dictionary: [
            "attachment": [
                "name": name,
                "mimetype": mimeType,
                "url": url,
                "preview_url": previewURL
            ]
            ]
        )
    }
    
    public func dictionaryValue() -> [String : Any]? {
        return dictionary
    }
}
