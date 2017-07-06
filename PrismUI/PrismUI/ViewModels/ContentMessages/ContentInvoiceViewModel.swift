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
    case bankTransfer = "bank_transfer"
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
        
        guard let totalPriceAmount = contentInvoice.grandTotal?.amount,
            let totalPrice = totalPriceAmount.formattedCurrency(),
            let items = contentInvoice.lineItems,
            let invoiceID = contentInvoice.id,
            let name = contentInvoice.buyer?.name,
            let phoneNumber = contentInvoice.buyer?.phoneNumber,
            let email = contentInvoice.buyer?.email,
            let paymentMethodID = contentInvoice.payment?.type else { return nil }
        
        self.invoiceID = invoiceID
        self.name = name
        self.phoneNumber = phoneNumber
        self.email = email
        
        self.totalPrice = "Total Price".localized() + " = " + totalPrice
        
        self.paymentMethod = PaymentMethod.value(with: paymentMethodID)
        
        for item in items {
            guard let vm = ContentInvoiceProductViewModel(contentItem: item) else { continue }
            self.productModels.append(vm)
        }
        
        if let shipment = contentInvoice.shipment {
            self.address = shipment.info?.address
            if let shipmentCost = shipment.cost?.amount?.formattedCurrency() {
                self.shippingCost = "Shipping Cost".localized() + " = " + shipmentCost
            }
        }
        
        self.midtransPaymentURL = contentInvoice.payment?.midtransPaymentURL
    }
}

class ContentInvoiceProductViewModel: ContentViewModel {
    var price: NSMutableAttributedString
    var name: String
    
    init?(contentItem: CDLineItem) {
        
        guard let name = contentItem.product?.name,
            let qty = contentItem.quantity,
            let priceAmount = contentItem.product?.price,
            var discAmount = contentItem.product?.discount?.amount,
            let priceString = priceAmount.formattedCurrency(),
            let discType = contentItem.product?.discount?.discountType else { return nil }
        
        self.name = name
        
        if discType == DiscountType.percentage {
            discAmount = (discAmount / 100) * priceAmount
        }
        
        let atts: [String: Any] = [NSFontAttributeName: UIFont.systemFont(ofSize: 14),
                                   NSForegroundColorAttributeName: UIColor.jetBlack]
        let prefix = "Price".localized() + " = "
        let suffix = "(Qty \(qty))"
        
        if discAmount > 0 {
            let linedAtts: [String: Any] = [NSFontAttributeName: UIFont.systemFont(ofSize: 14),
                                            NSForegroundColorAttributeName: UIColor.jetBlack.withAlphaComponent(0.5),
                                            NSBaselineOffsetAttributeName: NSNumber(value: 0),
                                            NSStrikethroughStyleAttributeName: NSNumber(value: 1)]
            
            guard let discString = (priceAmount - discAmount).formattedCurrency() else { return nil }
            
            let priceInfo = prefix + priceString + " " + discString + " " + suffix
            let range = (priceInfo as NSString).range(of: priceString)
            
            price = NSMutableAttributedString(string: priceInfo, attributes: atts)
            price.addAttributes(linedAtts, range: range)
        } else {
            let priceInfo = prefix.appending(priceString).appending(suffix)
            price = NSMutableAttributedString(string: priceInfo, attributes: atts)
        }
    }
}
