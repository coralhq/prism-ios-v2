//
//  CDContentProduct.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/23/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import PrismCore

class CDContentProduct: ValueTransformer, NSCoding {
    var product: CDProduct?
    
    init(contentProduct: ContentProduct) {
        product = CDProduct(product: contentProduct.product)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(product, forKey: "product")
    }
    
    required init?(coder aDecoder: NSCoder) {
        product = aDecoder.decodeObject(forKey: "product") as? CDProduct
    }
}
