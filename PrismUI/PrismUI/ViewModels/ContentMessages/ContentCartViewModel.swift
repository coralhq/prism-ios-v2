//
//  ContentCartViewModel.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 7/5/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation

struct DiscountType {
    static var nominal = "NOMINAL"
    static var percentage = "PERCENTAGE"
}

class ContentCartViewModel: ContentViewModel {
    var formattedPrice: String
    var itemViewModels: [ContentCartProductViewModel] = []
    
    init?(contentCart: CDContentCart) {
        let priceTitle = "Total Amount ".localized()
        
        guard let items = contentCart.lineItems else { return nil }
        
        var totalPrice: Double = 0
        
        for item in items {
            guard let priceString = item.product?.price,
                let discString = item.product?.discount?.amount,
                let discType = item.product?.discount?.discountType,
                let priceAmount = Double(priceString),
                let discAmount = Double(discString) else { continue }
            
            if discType == DiscountType.nominal {
                totalPrice += (priceAmount - discAmount)
            } else {
                totalPrice += priceAmount - (discAmount/100) * priceAmount
            }
            
            guard let vm = ContentCartProductViewModel(contentItem: item) else { continue }
            itemViewModels.append(vm)
        }
        
        guard let formattedPrice = totalPrice.formattedCurrency() else { return nil }
        self.formattedPrice = priceTitle.appending(formattedPrice)
    }
}

class ContentCartProductViewModel: ContentViewModel {
    var name: String
    var price: String
    var quantity: String
    var discount: String?
    var imageURL: URL?
    
    init?(contentItem: CDLineItem) {
        guard let name = contentItem.product?.name,
            let priceString = contentItem.product?.price,
            let priceAmount = Double(priceString),
            let priceFormatted = priceAmount.formattedCurrency(),
            let qty = contentItem.quantity else { return nil }
        self.name = name
        self.price = priceFormatted
        
        let qtyTitle = "Quantity: ".localized()
        self.quantity = qtyTitle.appending(String(qty))
        
        self.imageURL = contentItem.product?.imageURLs?.first
        
        if let discString = contentItem.product?.discount?.amount,
            var discAmount = Double(discString),
            let discType = contentItem.product?.discount?.discountType,
            discAmount > 0 {
            
            if discType == DiscountType.nominal {
                discAmount = priceAmount - discAmount
            } else {
                discAmount = priceAmount - (discAmount / 100) * priceAmount
            }
            self.discount = discAmount.formattedCurrency()
            
        }
    }
}
