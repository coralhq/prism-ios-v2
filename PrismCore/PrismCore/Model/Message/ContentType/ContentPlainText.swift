//
//  ContentPlainText.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

public class ContentPlainText : MessageContentMappable {
    let text: String
    
    public var dictionaryValue: [String: Any] {
        get {
            return ["text": text]
        }
    }

    required public init?(dictionary: [String : Any]?) {
        guard let text = dictionary?["text"] as? String else {
            return nil
        }
        
        self.text = text
    }
    
    convenience public init?(text: String) {
        self.init(dictionary: ["text": text])
    }
}
