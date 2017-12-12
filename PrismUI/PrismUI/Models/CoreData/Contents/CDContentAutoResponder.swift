//
//  CDContentAutoResponder.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 12/12/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

class CDContentAutoResponder: ValueTransformer, NSCoding, CDMappable {
    var text: String
    var workingHour: Bool
    
    required init?(dictionary: [String : Any]) {
        let autorespond = dictionary["auto_responder"] as! [String: Any]
        
        text = autorespond["text"] as! String
        workingHour = autorespond["working_hour"] as! Bool
    }
    
    func dictionaryValue() -> [String : Any] {
        return [
            "text": text,
            "working_hour": workingHour
        ]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "text")
        aCoder.encode(workingHour, forKey: "working_hour")
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "text") as! String
        workingHour = aDecoder.decodeBool(forKey: "working_hour")
    }
}
