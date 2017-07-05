//
//  CDContentPlainText.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/23/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import PrismCore

class CDContentPlainText: ValueTransformer, NSCoding {
    var text: String?
    
    init(plainText: ContentPlainText) {
        text = plainText.text
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "text")
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "text") as? String
    }
}
