//
//  ContentInvoiceViewModel.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 7/5/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation

enum PaymentMethod: String {
    case midtrans = "vt_web"
    case bankTransfer = "transfer"
    case cod = "cod"
    case unknown = "unknown"
    
    static func value(with identifier: String) -> PaymentMethod {
        if let pm = PaymentMethod(rawValue: identifier) {
            return pm
        } else {
            return PaymentMethod(rawValue: "unknown")!
        }
    }
    
    func name() -> String {
        switch self {
        case .bankTransfer:
            return "Bank Transfer"
        case .midtrans:
            return "Midtrans"
        case .cod:
            return "Cash On Delivery"
        case .unknown:
            return rawValue
        }
    }
}

class ContentInvoiceViewModel: ContentViewModel {
    let invoiceID: String
    let name: String
    let phoneNumber: String
    let email: String
    let paymentMethod: PaymentMethod
    let totalPrice: String
    var address: String?
    var shippingCost: String?
    var midtransPaymentURL: URL?
    var productModels: [ContentInvoiceProductViewModel] = []
    
    init?(contentInvoice: CDContentInvoice) {
        
        self.invoiceID = contentInvoice.id
        self.name = contentInvoice.buyer.name
        self.phoneNumber = contentInvoice.buyer.phoneNumber
        self.email = contentInvoice.buyer.email
        
        let totalAmount = Double(contentInvoice.grandTotal.amount)!
        self.totalPrice = "Total Price".localized() + " = " + totalAmount.formattedCurrency()!
        self.paymentMethod = PaymentMethod.value(with: contentInvoice.payment.provider.type)
        
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
        
        if let info = contentInvoice.payment.provider.info as? CDMidtransInfo {
            self.midtransPaymentURL = URL(string: info.redirectURL)
        }
    }
}

class ContentInvoiceProductViewModel: ContentViewModel {
    var price: NSMutableAttributedString
    var name: String
    
    init?(contentItem: CDLineItem) {
        self.name = contentItem.product.name
        
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
