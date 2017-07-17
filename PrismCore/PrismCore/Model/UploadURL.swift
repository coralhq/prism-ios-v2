//
//  UploadURL.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/23/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

open class UploadURL: Mappable {
    public let uploadURL: URL
    
    required public init?(dictionary: [String : Any]?) {
        guard let data = dictionary?["data"] as? [String: Any],
            let stringURL = data["upload_url"] as? String
            else {
                return nil
        }
        self.uploadURL = URL(string: stringURL)!
    }
    
    public func dictionaryValue() -> [String : Any] {
        return ["data": ["upload_url": uploadURL.absoluteString]]
    }
}
