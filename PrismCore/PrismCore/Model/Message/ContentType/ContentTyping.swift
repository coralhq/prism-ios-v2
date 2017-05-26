//
//  ContentTyping.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

class ContentTyping: MessageContentMappable {
    
    let status: String
    
    required init?(json: [String : Any]?) {
        guard let typing = json?["typing"] as? [String: Any],
            let status = typing["status"] as? String else {
                return nil
        }
        
        self.status = status
    }
}
