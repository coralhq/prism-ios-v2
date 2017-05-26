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
    
    required init?(json: [String : Any]?) {
        guard let cart = json?["cart"] as? [String: Any],
            let lineItemsJson = cart["line_items"] as? [[String: Any]] else {
                return nil
        }
        
        var lineItems = [LineItem]()
        for json in lineItemsJson {
            guard let lineItem = LineItem(json: json) else {
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
    
    required init?(json: [String : Any]?) {
        guard let product = Product(json: json?["product"] as? [String: Any]),
        let quantity = json?["quantity"] as? Int else {
            return nil
        }
        
        self.product = product
        self.quantity = quantity
    }
}

class Discount: Mappable {
    let discountType: String
    let amount: String
    
    required init?(json: [String : Any]?) {
        guard let discountType = json?["discount_type"] as? String,
        let amount = json?["amount"] as? String else {
            return nil
        }
        
        self.amount = amount
        self.discountType = discountType
    }
}
