//
//  ContentTyping.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

public class ContentTyping: MessageContentMappable {
    
    public let status: String
    public var dictionaryValue: [String: Any] {
        get {
            return [
                "typing": [
                    "status": status
                ]
            ]
        }
    }
    
    required public init?(dictionary: [String : Any]?) {
        guard let typing = dictionary?["typing"] as? [String: Any],
            let status = typing["status"] as? String else {
                return nil
        }
        
        self.status = status
    }
    
    convenience public init?(status: TypingStatus) {
        self.init(dictionary: [
            "typing": [
                "status": status.rawValue
                ]
            ]
        )
    }
}
