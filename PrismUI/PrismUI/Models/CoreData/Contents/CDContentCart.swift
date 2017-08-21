//
//  CDContentCart.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/23/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import PrismCore

class CDContentCart: ValueTransformer, NSCoding, CDMappable {
    var lineItems: [CDLineItem]
    
    required init?(dictionary: [String : Any]) {
        guard let cart = dictionary["cart"] as? [String: Any],
            let items = cart["line_items"] as? [[String: Any]] else {
                return nil
        }
        
        lineItems = []
        for item in items {
            lineItems.append(CDLineItem(dictionary: item)!)
        }
    }
    
    func dictionaryValue() -> [String : Any] {
        var items: [[String: Any]] = []
        for item in lineItems {
            items.append(item.dictionaryValue())
        }
        return ["cart": ["line_items": items]]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(lineItems, forKey: "line_items")
    }
    
    required init?(coder aDecoder: NSCoder) {
        lineItems = aDecoder.decodeObject(forKey: "line_items") as! [CDLineItem]
    }
}

class CDLineItem: NSObject, NSCoding, CDMappable {
    var product: CDProduct
    var quantity: Int
    
    required init?(dictionary: [String : Any]) {
        guard let product = dictionary["product"] as? [String: Any],
            let quantity = dictionary["quantity"] as? Int else {
                return nil
        }
        self.product = CDProduct(dictionary: product)!
        self.quantity = quantity
    }
    
    func dictionaryValue() -> [String : Any] {
        return ["product": product,
                "quantity": quantity]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(product, forKey: "product")
        aCoder.encode(quantity, forKey: "quantity")
    }
    
    required init?(coder aDecoder: NSCoder) {
        product = aDecoder.decodeObject(forKey: "product") as! CDProduct
        quantity = aDecoder.decodeInteger(forKey: "quantity")
    }
}

class CDProduct: NSObject, NSCoding, CDMappable {
    var id: String
    var name: String
    var price: String
    var desc: String?
    var imageURLs: [URL]
    var discount: CDDiscount?
    var currencyCode: String
    
    required init?(dictionary: [String : Any]) {
        id = dictionary["id"] as! String
        name = dictionary["name"] as! String
        price = dictionary["price"] as! String
        imageURLs = (dictionary["image_urls"] as! [String]).map { (url) -> URL in
            return URL(string: url)!
        }
        currencyCode = dictionary["currency_code"] as! String
        
        if let discount = dictionary["discount"] as? [String: Any] {
            self.discount = CDDiscount(dictionary: discount)!
        }
        if let desc = dictionary["description"] as? String {
            self.desc = desc
        }
    }
    
    func dictionaryValue() -> [String : Any] {
        var result: [String: Any] = ["id": id,
                                     "name": name,
                                     "price": price,
                                     "image_urls": imageURLs]
        if let discount = self.discount {
            result["discount"] = discount.dictionaryValue()
        }
        if let desc = self.desc {
            result["desc"] = desc
        }
        return result
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
        id = aDecoder.decodeObject(forKey: "id") as! String
        name = aDecoder.decodeObject(forKey: "name") as! String
        price = aDecoder.decodeObject(forKey: "price") as! String
        desc = aDecoder.decodeObject(forKey: "description") as? String
        imageURLs = aDecoder.decodeObject(forKey: "image_urls") as! [URL]
        discount = aDecoder.decodeObject(forKey: "discount") as? CDDiscount
        currencyCode = aDecoder.decodeObject(forKey: "currency_code") as! String
    }
}

class CDDiscount: NSObject, NSCoding, CDMappable {
    var discountType: String
    var amount: String
    
    required init?(dictionary: [String : Any]) {
        discountType = dictionary["discount_type"] as! String
        amount = dictionary["amount"] as! String
    }
    
    func dictionaryValue() -> [String : Any] {
        return ["discount_type": discountType,
                "amount": amount]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(discountType, forKey: "discount_type")
        aCoder.encode(amount, forKey: "amount")
    }
    
    required init?(coder aDecoder: NSCoder) {
        discountType = aDecoder.decodeObject(forKey: "discount_type") as! String
        amount = aDecoder.decodeObject(forKey: "amount") as! String
    }
}
