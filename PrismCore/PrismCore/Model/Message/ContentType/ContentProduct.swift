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
    
    required init?(dictionary: [String : Any]?) {
        guard let product = Product(dictionary: dictionary?["product"] as? [String: Any]) else {
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
    
    required init?(dictionary: [String : Any]?) {
        guard let id = dictionary?["id"] as? String,
            let name = dictionary?["name"] as? String,
            let price = dictionary?["price"] as? String,
            let description = dictionary?["description"] as? String,
            let imageURLDictionaries = dictionary?["image_urls"] as? [String],
            let discount = Discount(dictionary: dictionary?["discount"] as? [String: Any]),
            let currencyCode = dictionary?["currency_code"] as? String else {
                return nil
        }
        
        var imageURLs: [URL] = []
        for dictionary in imageURLDictionaries {
            guard let url = URL(string: dictionary) else {
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
