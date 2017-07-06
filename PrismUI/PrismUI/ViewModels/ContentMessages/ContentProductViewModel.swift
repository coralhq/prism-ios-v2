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
    var description: String
    var discount: String?
    var imageURLs: [URL]
    
    init?(contentProduct: CDContentProduct) {
        guard let name = contentProduct.product?.name,
            let priceAmount = contentProduct.product?.price,
            let priceString = priceAmount.formattedCurrency(),
            var discAmount = contentProduct.product?.discount?.amount,
            let discType = contentProduct.product?.discount?.discountType,
            let description = contentProduct.product?.desc,
            let imageURLs = contentProduct.product?.imageURLs else { return nil }
        
        self.name = name
        self.price = priceString
        self.description = description
        self.imageURLs = imageURLs
        
        if discType == DiscountType.percentage {
            discAmount = (discAmount / 100) * priceAmount
        }
        if discAmount > 0 {
            discount = (priceAmount - discAmount).formattedCurrency()
        }
    }
}
