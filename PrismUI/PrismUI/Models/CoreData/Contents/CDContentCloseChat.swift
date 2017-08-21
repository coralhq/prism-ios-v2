//
//  CDContentCloseChat.swift
//  PrismUI
//
//  Created by fanni suyuti on 8/2/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import PrismCore

class CDContentCloseChat: ValueTransformer, NSCoding, CDMappable {
    var text: String
    
    required init?(dictionary: [String : Any]) {
        let closeChat = dictionary["close_chat"] as! [String: Any]
        let message = closeChat["message"] as! [String: Any]
        text = message["text"] as! String
    }
    
    func dictionaryValue() -> [String : Any] {
        return ["text": text]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "text")
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "text") as! String
    }
}
