//
//  UploadURL.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/23/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

open class UploadURL: Mappable {
    let uploadURL: URL
    
    required public init?(json: [String : Any]?) {
        guard let data = json?["data"] as? [String: Any],
            let uploadURL = data["upload_url"] as? URL
            else {
                return nil
        }
        
        self.uploadURL = uploadURL
    }
}
