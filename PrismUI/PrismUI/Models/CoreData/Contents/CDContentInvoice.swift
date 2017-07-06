//
//  CDContentInvoice.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/23/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import PrismCore

class CDContentInvoice: ValueTransformer, NSCoding {
    var id: String?
    var lineItems: [CDLineItem]?
    var grandTotal: CDCurrency?
    var buyer: CDBuyer?
    var shipment: CDShipment?
    var payment: CDPayment?
    
    init(invoice: ContentInvoice) {
        id = invoice.id
        grandTotal = CDCurrency(currency: invoice.grandTotal)
        buyer = CDBuyer(buyer: invoice.buyer)
        payment = CDPayment(payment: invoice.payment)
        
        if let shipment = invoice.shipment {
            self.shipment = CDShipment(shipment: shipment)
        }
        
        lineItems = []
        for lineItem in invoice.lineItems {
            lineItems?.append(CDLineItem(lineItem: lineItem))
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(lineItems, forKey: "line_items")
        aCoder.encode(grandTotal, forKey: "grand_total")
        aCoder.encode(buyer, forKey: "buyer")
        aCoder.encode(shipment, forKey: "shipment")
        aCoder.encode(payment, forKey: "payment")
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "id") as? String
        lineItems = aDecoder.decodeObject(forKey: "line_items") as? [CDLineItem]
        grandTotal = aDecoder.decodeObject(forKey: "grand_total") as? CDCurrency
        buyer = aDecoder.decodeObject(forKey: "buyer") as? CDBuyer
        shipment = aDecoder.decodeObject(forKey: "shipment") as? CDShipment
        payment = aDecoder.decodeObject(forKey: "payment") as? CDPayment
    }
}

class CDCurrency: NSObject, NSCoding {
    var currencyCode: String?
    var amount: Double?
    
    init(currency: Currency) {
        currencyCode = currency.currencyCode
        amount = Double(currency.amount)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(currencyCode, forKey: "currency_code")
        aCoder.encode(amount, forKey: "amount")
    }
    
    required init?(coder aDecoder: NSCoder) {
        currencyCode = aDecoder.decodeObject(forKey: "currency_code") as? String
        amount = aDecoder.decodeObject(forKey: "amount") as? Double
    }
}

class CDBuyer: NSObject, NSCoding {
    var name: String?
    var email: String?
    var phoneNumber: String?
    
    init(buyer: Buyer) {
        name = buyer.name
        email = buyer.email
        phoneNumber = buyer.phoneNumber
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(phoneNumber, forKey: "phone_number")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
        phoneNumber = aDecoder.decodeObject(forKey: "phone_number") as? String
    }
}

class CDShipment: NSObject, NSCoding {
    var info: CDShipmentInfo?
    var cost: CDCurrency?
    
    init(shipment: Shipment) {
        info = CDShipmentInfo(shipmentInfo: shipment.info)
        cost = CDCurrency(currency: shipment.cost)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(info, forKey: "info")
        aCoder.encode(cost, forKey: "cost")
    }
    
    required init?(coder aDecoder: NSCoder) {
        info = aDecoder.decodeObject(forKey: "info") as? CDShipmentInfo
        cost = aDecoder.decodeObject(forKey: "cost") as? CDCurrency
    }
}

class CDShipmentInfo: NSObject, NSCoding {
    var name: String?
    var email: String?
    var address: String?
    var phone: String?
    
    init(shipmentInfo: ShipmentInfo) {
        name = shipmentInfo.name
        email = shipmentInfo.email
        address = shipmentInfo.address
        phone = shipmentInfo.phone
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(phone, forKey: "phone")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
        address = aDecoder.decodeObject(forKey: "address") as? String
        phone = aDecoder.decodeObject(forKey: "phone") as? String
    }
}

class CDPayment: NSObject, NSCoding {
    var type: String?
    var midtransPaymentURL: URL?
    
    init(payment: Payment) {
        type = payment.type
        midtransPaymentURL = payment.midtransPaymentURL
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(type, forKey: "type")
        aCoder.encode(midtransPaymentURL, forKey: "midtrans_payment_url")
    }
    
    required init?(coder aDecoder: NSCoder) {
        type = aDecoder.decodeObject(forKey: "type") as? String
        midtransPaymentURL = aDecoder.decodeObject(forKey: "midtrans_payment_url") as? URL
    }
}
