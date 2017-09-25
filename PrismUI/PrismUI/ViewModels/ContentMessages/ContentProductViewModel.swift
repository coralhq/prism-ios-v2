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
    let options: String?
    let notes: String?
    
    init?(contentProduct: CDContentProduct) {
        let product = contentProduct.product
        
        self.name = product.name
        let priceAmount = Double(product.price)!
        self.price = priceAmount.formattedCurrency(currencyCode: product.currencyCode)
        self.description = product.desc
        self.imageURLs = product.imageURLs
        
        if let discount = product.discount {
            var discAmount = Double(discount.amount)!
            if discount.discountType == DiscountType.percentage {
                discAmount = (discAmount / 100) * priceAmount
            }
            if discAmount > 0 {
                self.discount = (priceAmount - discAmount).formattedCurrency(currencyCode: product.currencyCode)
            }
        }
        
        self.notes = product.notes
        self.options = Utils.formatted(selectedOptions: product.selectedOptions,
                                       with: product.options)
    }
}
