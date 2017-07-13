//
//  CDContentPlainText.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/23/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import PrismCore

public protocol CDMappable {
    init?(dictionary: [String: Any])
    func dictionaryValue() -> [String: Any]
}

class CDContentPlainText: ValueTransformer, NSCoding, CDMappable {
    var text: String
    
    required init?(dictionary: [String : Any]) {
        text = dictionary["text"] as! String
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
