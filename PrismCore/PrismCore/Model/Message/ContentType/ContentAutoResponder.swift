//
//  ContentAutoResponder.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

class ContentAutoResponder: MessageContentMappable {
    let text: String
    let workingHour: Bool
    var dictionary: [String: Any]?
    
    required init?(dictionary: [String : Any]?) {
        guard let autoResponder = dictionary?["auto_responder"] as? [String: Any],
            let text = autoResponder["text"] as? String,
            let workingHour = autoResponder["working_hour"] as? Bool else {
                return nil
        }
        
        self.dictionary = dictionary
        
        self.text = text
        self.workingHour = workingHour
    }
    
    func dictionaryValue() -> [String : Any] {
        return ["auto_responder": ["text": text,
                                   "working_hour": workingHour]]
    }
}
