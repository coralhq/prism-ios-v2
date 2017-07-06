//
//  ContentPlainText.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

public class ContentPlainText : MessageContentMappable {
    public let text: String
    
    var dictionary: [String: Any]?

    required public init?(dictionary: [String : Any]?) {
        self.dictionary = dictionary
        guard let text = dictionary?["text"] as? String else {
            return nil
        }
        self.text = text
    }
    
    convenience public init?(text: String) {
        self.init(dictionary: ["text": text])
    }
    
    public func dictionaryValue() -> [String : Any]? {
        return dictionary
    }
}
