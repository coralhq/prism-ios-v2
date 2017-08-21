//
//  CDContentProduct.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/23/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import PrismCore

class CDContentProduct: ValueTransformer, NSCoding, CDMappable {
    var product: CDProduct
    
    required init?(dictionary: [String : Any]) {
        product = CDProduct(dictionary: dictionary["product"] as! [String: Any])!
    }
    
    public func dictionaryValue() -> [String : Any] {
        return ["product": product.dictionaryValue()]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(product, forKey: "product")
    }
    
    required init?(coder aDecoder: NSCoder) {
        product = aDecoder.decodeObject(forKey: "product") as! CDProduct
    }
}
