//
//  ContentProduct.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

class ContentProduct: MessageContentMappable {
    let product: Product
    
    required init?(json: [String : Any]?) {
        guard let product = Product(json: json?["product"] as? [String: Any]) else {
            return nil
        }
        
        self.product = product
    }
}

class Product: Mappable {
    let id: String
    let name: String
    let price: String
    let description: String
    let imageURLs: [URL]
    let discount: Discount
    let currencyCode: String
    
    required init?(json: [String : Any]?) {
        guard let id = json?["id"] as? String,
            let name = json?["name"] as? String,
            let price = json?["price"] as? String,
            let description = json?["description"] as? String,
            let imageURLJsons = json?["image_urls"] as? [String],
            let discount = Discount(json: json?["discount"] as? [String: Any]),
            let currencyCode = json?["currency_code"] as? String else {
                return nil
        }
        
        var imageURLs: [URL] = []
        for json in imageURLJsons {
            guard let url = URL(string: json) else {
                return nil
            }
            
            imageURLs.append(url)
        }
        
        self.id = id
        self.name = name
        self.price = price
        self.description = description
        self.imageURLs = imageURLs
        self.discount = discount
        self.currencyCode = currencyCode
    }
}
