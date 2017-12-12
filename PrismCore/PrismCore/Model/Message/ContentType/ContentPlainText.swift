//
//  ContentPlainText.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

open class ContentPlainText : MessageContentMappable {
    public let text: String
    
    required public init?(dictionary: [String : Any]?) {
        guard let text = dictionary?["text"] as? String else {
            return nil
        }
        self.text = text
    }
    
    convenience public init?(text: String) {
        self.init(dictionary: ["text": text])
    }
    
    public func dictionaryValue() -> [String : Any] {
        return ["text": text]
    }
}
