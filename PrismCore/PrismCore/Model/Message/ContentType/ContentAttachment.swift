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
    public var url: String? = nil
    public var previewURL: String? = nil
    
    required public init?(dictionary: [String: Any]?) {
        guard let attachment = dictionary?["attachment"] as? [String: Any],
            let name = attachment["name"] as? String,
            let mimeType = attachment["mimetype"] as? String else {
                return nil
        }
        self.name = name
        self.mimeType = mimeType
        
        previewURL = attachment["preview_url"] as? String
        url = attachment["url"] as? String
    }
    
    public init(name: String, mimeType: String, url: String? = nil, previewURL: String? = nil) {
        self.name = name
        self.mimeType = mimeType
        self.url = url
        self.previewURL = url
    }
    
    public func dictionaryValue() -> [String : Any]? {
        var attDict: [String: Any] = ["name": name,
                                      "mimetype": mimeType]
        if let url = url {
            attDict["url"] = url
        }
        if let previewURL = previewURL {
            attDict["preview_url"] = previewURL
        }
        return ["attachment": attDict]
    }
}
