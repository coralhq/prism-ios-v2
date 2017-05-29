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
    
    required public init?(json: [String : Any]?) {
        if let data = json?["data"] as? [String : Any] {
            print("data \(data)")
            if let url = data["upload_url"] {
                print("url \(url)")
            }
        }
        guard let data = json?["data"] as? [String: Any],
            let stringURL = data["upload_url"] as? String
            else {
                return nil
        }
        
        self.uploadURL = URL(string: stringURL)!
    }
}
