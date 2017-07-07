//
//  ContentProduct.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

public class ContentProduct: MessageContentMappable {
    public let product: Product
    var dictionary: [String: Any]?
    
    required public init?(dictionary: [String : Any]?) {
        self.dictionary = dictionary
        
        guard let product = Product(dictionary: dictionary?["product"] as? [String: Any]) else {
            return nil
        }
        
        self.product = product
    }
    
    public func dictionaryValue() -> [String : Any]? {
        return dictionary
    }
}

public class Product: Mappable {
    public let id: String
    public let name: String
    public let price: String
    public let description: String
    public let imageURLs: [URL]
    public let discount: Discount
    public let currencyCode: String
    
    required public init?(dictionary: [String : Any]?) {
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
