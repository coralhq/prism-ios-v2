//
//  ContentInvoiceViewModel.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 7/5/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import UIKit

class BankInfoViewModel {
    let accountNumber: String
    let accountHolder: String
    let bankName: String
    
    init(info: CDBankTransferInfo) {
        accountNumber = info.accountNumber
        accountHolder = info.accountHolder
        bankName = info.bankName
    }
}

class PaymentProviderViewModel {
    let name: String
    let type: String
    let url: URL?
    let bankInfo: BankInfoViewModel?
    
    init(provider: CDPaymentProvider) {
        type = provider.type
        
        if let info = provider.info as? CDMidtransInfo {
            name = "Midtrans"
            url = URL(string: info.redirectURL)
            bankInfo = nil
        } else if let info = provider.info as? CDPaymentLinkInfo {
            name = info.label
            if let url = info.url {
                self.url = URL(string: url)
            } else {
                self.url = nil
            }
            bankInfo = nil
        } else if let info = provider.info as? CDBankTransferInfo {
            name = "Bank Transfer"
            url = nil
            bankInfo = BankInfoViewModel(info: info)
        } else {
            name = "Cash On Delivery"
            url = nil
            bankInfo = nil
        }
    }
}

class ContentInvoiceViewModel: ContentViewModel {
    let invoiceID: String
    let name: String
    let phoneNumber: String
    let email: String
    let payment: PaymentProviderViewModel
    let totalPrice: String
    var address: String?
    var shippingCost: String?
    var productModels: [ContentInvoiceProductViewModel] = []
    let invoiceTime: String?
    let notes: String?
    
    init?(contentInvoice: CDContentInvoice, messageTime: Date) {
        self.invoiceID = contentInvoice.id
        self.name = contentInvoice.buyer.name
        self.phoneNumber = contentInvoice.buyer.phoneNumber
        self.email = contentInvoice.buyer.email
        
        let totalAmount = Double(contentInvoice.grandTotal.amount)!
        self.totalPrice = "Total Price".localized() + " = " + totalAmount.formattedCurrency()!
        self.payment = PaymentProviderViewModel(provider: contentInvoice.payment.provider)
        
        for item in contentInvoice.lineItems {
            guard let vm = ContentInvoiceProductViewModel(contentItem: item) else { continue }
            self.productModels.append(vm)
        }
        
        if let shipment = contentInvoice.shipment {
            self.address = shipment.info.address
            let cost = Double(shipment.cost.amount)!
            if let shipmentCost = cost.formattedCurrency() {
                self.shippingCost = "Shipping Cost".localized() + " = " + shipmentCost
            }
        }
        
        self.invoiceTime = Vendor.shared.getLocalDateWith(date: messageTime, format: "EEE MMM dd, hh:mm a")
        self.notes = contentInvoice.notes
    }
}

class ContentInvoiceProductViewModel: ContentViewModel {
    var price: NSMutableAttributedString
    var name: String
    let notes: String?
    let options: String?
    
    init?(contentItem: CDLineItem) {
        self.name = contentItem.product.name
        self.notes = contentItem.product.notes
        self.options = Utils.formatted(selectedOptions: contentItem.product.selectedOptions,
                                       with: contentItem.product.options)
        
        let priceAmount = Double(contentItem.product.price)!
        let priceString = priceAmount.formattedCurrency()!
        
        let prefix = "Price".localized() + " = "
        let suffix = "(Qty \(contentItem.quantity))"
        let atts: [String: Any] = [NSFontAttributeName: UIFont.systemFont(ofSize: 14),
                                   NSForegroundColorAttributeName: UIColor.jetBlack]
        
        if let discount = contentItem.product.discount {
            let linedAtts: [String: Any] = [NSFontAttributeName: UIFont.systemFont(ofSize: 14),
                                            NSForegroundColorAttributeName: UIColor.jetBlack.withAlphaComponent(0.5),
                                            NSBaselineOffsetAttributeName: NSNumber(value: 0),
                                            NSStrikethroughStyleAttributeName: NSNumber(value: 1)]
            let discAmount = Double(discount.amount)!
            let discString = (priceAmount - discAmount).formattedCurrency()!
            let priceInfo = prefix + priceString + " " + discString + " " + suffix
            let range = (priceInfo as NSString).range(of: priceString)
            
            price = NSMutableAttributedString(string: priceInfo, attributes: atts)
            price.addAttributes(linedAtts, range: range)
        } else {
            let priceInfo = prefix + priceString + " " + suffix
            price = NSMutableAttributedString(string: priceInfo, attributes: atts)
        }
    }
}
