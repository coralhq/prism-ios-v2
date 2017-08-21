//
//  ContentProductViewModel.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 7/6/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation

class ContentProductViewModel: ContentViewModel {
    var name: String
    var price: String
    var description: String?
    var discount: String?
    var imageURLs: [URL]
    
    init?(contentProduct: CDContentProduct) {
        self.name = contentProduct.product.name
        let priceAmount = Double(contentProduct.product.price)!
        self.price = priceAmount.formattedCurrency()!
        self.description = contentProduct.product.desc
        self.imageURLs = contentProduct.product.imageURLs
        
        if let discount = contentProduct.product.discount {
            var discAmount = Double(discount.amount)!
            if discount.discountType == DiscountType.percentage {
                discAmount = (discAmount / 100) * priceAmount
            }
            if discAmount > 0 {
                self.discount = (priceAmount - discAmount).formattedCurrency()
            }
        }
    }
}
