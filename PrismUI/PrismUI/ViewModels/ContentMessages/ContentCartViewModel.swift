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
        
        var totalPrice: Double = 0
        
        for item in contentCart.lineItems {
            let priceAmount = Double(item.product.price)!
            
            if let discount = item.product.discount {
                let discAmount = Double(discount.amount)!
                
                if discount.discountType == DiscountType.nominal {
                    totalPrice += (priceAmount - discAmount)
                } else {
                    totalPrice += priceAmount - (discAmount / 100) * priceAmount
                }
            } else {
                totalPrice += priceAmount
            }
            
            guard let vm = ContentCartProductViewModel(contentItem: item) else { continue }
            itemViewModels.append(vm)
        }
        
        let currencyCode = contentCart.lineItems.first?.product.currencyCode
        self.formattedPrice = "Total Amount" + ": " + totalPrice.formattedCurrency(currencyCode: currencyCode)
    }
}

class ContentCartProductViewModel: ContentViewModel {
    var name: String
    var price: String
    var quantity: String
    var discount: String?
    var imageURL: URL?
    
    let options: String?
    let notes: String?
    
    init?(contentItem: CDLineItem) {
        let product = contentItem.product
        
        let priceAmount = Double(product.price)!
        self.price = priceAmount.formattedCurrency(currencyCode: product.currencyCode)
        self.name = product.name
        self.quantity = "Quantity".localized() + ": " + String(contentItem.quantity)
        self.imageURL = product.imageURLs.count > 0 ? product.imageURLs.first : nil
        
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
