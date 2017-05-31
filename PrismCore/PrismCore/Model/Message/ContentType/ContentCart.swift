//
//  ContentCart.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

class ContentCart: MessageContentMappable {
    let lineItems: [LineItem]
    
    required init?(dictionary: [String : Any]?) {
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
}

class LineItem : Mappable {
    let product: Product
    let quantity: Int
    
    required init?(dictionary: [String : Any]?) {
        guard let product = Product(dictionary: dictionary?["product"] as? [String: Any]),
        let quantity = dictionary?["quantity"] as? Int else {
            return nil
        }
        
        self.product = product
        self.quantity = quantity
    }
}

class Discount: Mappable {
    let discountType: String
    let amount: String
    
    required init?(dictionary: [String : Any]?) {
        guard let discountType = dictionary?["discount_type"] as? String,
        let amount = dictionary?["amount"] as? String else {
            return nil
        }
        
        self.amount = amount
        self.discountType = discountType
    }
}
