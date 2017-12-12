//
//  ContentCart.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

open class ContentCart: MessageContentMappable {
    public let lineItems: [LineItem]
    
    required public init?(dictionary: [String : Any]?) {
        
        guard let cart = dictionary?["cart"] as? [String: Any],
            let lineItemDictionaries = cart["line_items"] as? [[String: Any]] else {
                return nil
        }
        
        var lineItems = [LineItem]()
        for dictionary in lineItemDictionaries {
            guard let lineItem = LineItem(dictionary: dictionary) else {
                return nil
            }
            
            lineItems.append(lineItem)
        }
        
        self.lineItems = lineItems
    }
    
    public func dictionaryValue() -> [String : Any] {
        var items: [[String: Any]] = []
        for item in lineItems {
            items.append(item.dictionaryValue())
        }
        return ["cart": ["line_items": items]]
    }
}

open class LineItem : NSObject, Mappable {
    public let product: Product
    public let quantity: Int
    
    required public init?(dictionary: [String : Any]?) {
        guard let product = Product(dictionary: dictionary?["product"] as? [String: Any]),
            let quantity = dictionary?["quantity"] as? Int else {
                return nil
        }
        self.product = product
        self.quantity = quantity
    }
    
    public func dictionaryValue() -> [String : Any] {
        return ["product": product.dictionaryValue(),
                "quantity": quantity]
    }
}

open class Discount: NSObject, Mappable {
    public let discountType: String
    public let amount: String
    
    required public init?(dictionary: [String : Any]?) {
        guard let discountType = dictionary?["discount_type"] as? String,
            let amount = dictionary?["amount"] as? String else {
                return nil
        }
        
        self.amount = amount
        self.discountType = discountType
    }
    
    public func dictionaryValue() -> [String : Any] {
        return ["discount_type": discountType,
                "amount": amount]
    }
}
