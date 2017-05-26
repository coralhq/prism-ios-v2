//
//  ContentPlainText.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

class ContentPlainText : MessageContentMappable {
    let text: String
    
    required init?(json: [String : Any]?) {
        guard let text = json?["text"] as? String else {
            return nil
        }
        
        self.text = text
    }
}
