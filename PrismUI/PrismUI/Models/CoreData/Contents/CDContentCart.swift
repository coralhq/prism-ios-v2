//
//  CDContentCart.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/23/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import PrismCore

class CDContentCart: ValueTransformer, NSCoding {
    var lineItems: [CDLineItem]?
    
    init(cart: ContentCart) {
        lineItems = []
        for lineItem in cart.lineItems {
            lineItems?.append(CDLineItem(lineItem: lineItem))
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(lineItems, forKey: "line_items")
    }
    
    required init?(coder aDecoder: NSCoder) {
        lineItems = aDecoder.decodeObject(forKey: "line_items") as? [CDLineItem]
    }
}

class CDLineItem: NSObject, NSCoding {
    var product: CDProduct?
    var quantity: Int?
    
    init(lineItem: LineItem) {
        quantity = lineItem.quantity
        product = CDProduct(product: lineItem.product)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(product, forKey: "product")
        aCoder.encode(quantity, forKey: "quantity")
    }
    
    required init?(coder aDecoder: NSCoder) {
        product = aDecoder.decodeObject(forKey: "product") as? CDProduct
        quantity = aDecoder.decodeInteger(forKey: "quantity")
    }
}

class CDProduct: NSObject, NSCoding {
    var id: String?
    var name: String?
    var price: String?
    var desc: String?
    var imageURLs: [URL]?
    var discount: CDDiscount?
    var currencyCode: String?
    
    init(product: Product) {
        id = product.id
        name = product.name
        price = product.price
        desc = product.description
        imageURLs = product.imageURLs
        discount = CDDiscount(discount: product.discount)
        currencyCode = product.currencyCode
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(desc, forKey: "description")
        aCoder.encode(imageURLs, forKey: "image_urls")
        aCoder.encode(discount, forKey: "discount")
        aCoder.encode(currencyCode, forKey: "currency_code")
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "id") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        price = aDecoder.decodeObject(forKey: "price") as? String
        desc = aDecoder.decodeObject(forKey: "description") as? String
        imageURLs = aDecoder.decodeObject(forKey: "image_urls") as? [URL]
        discount = aDecoder.decodeObject(forKey: "discount") as? CDDiscount
        currencyCode = aDecoder.decodeObject(forKey: "currency_code") as? String
    }
}

class CDDiscount: NSObject, NSCoding {
    var discountType: String?
    var amount: String?
    
    init(discount: Discount) {
        discountType = discount.discountType
        amount = discount.amount
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(discountType, forKey: "discount_type")
        aCoder.encode(amount, forKey: "amount")
    }
    
    required init?(coder aDecoder: NSCoder) {
        discountType = aDecoder.decodeObject(forKey: "discount_type") as? String
        amount = aDecoder.decodeObject(forKey: "amount") as? String
    }
}
