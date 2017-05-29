//
//  ContentInvoice.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

class ContentInvoice: MessageContentMappable {
    
    let id: String
    let lineItems: [LineItem]
    let grandTotal: Currency
    let buyer: Buyer
    let shipment: Shipment
    let payment: Payment
    
    required init?(json: [String : Any]?) {
        guard let id = json?["id"] as? String,
            let lineItemsJson = json?["line_items"] as? [[String: Any]],
            let grandTotal = Currency(json: json?["grand_total"] as? [String: Any]),
            let buyer = Buyer(json: json?["buyer"] as? [String: Any]),
            let shipment = Shipment(json: json?["shipment"] as? [String: Any]),
            let payment = Payment(json: json?["paument"] as? [String: Any]) else {
                return nil
        }
        
        var lineItems = [LineItem]()
        for json in lineItemsJson {
            guard let lineItem = LineItem(json: json) else {
                return nil
            }
            
            lineItems.append(lineItem)
        }
        
        self.id = id
        self.lineItems = lineItems
        self.grandTotal = grandTotal
        self.buyer = buyer
        self.shipment = shipment
        self.payment = payment
    }
}

class Payment: Mappable {
    let type: String
    
    required init?(json: [String : Any]?) {
        guard let provider = json?["provider"] as? [String: Any],
            let type = provider["type"] as? String else {
                return nil
        }
        
        self.type = type
    }
}

class Shipment: Mappable {
    let info: ShipmentInfo
    let cost: Currency
    
    required init?(json: [String : Any]?) {
        guard let info = ShipmentInfo(json: json?["info"] as? [String: Any]),
            let cost = Currency(json: json?["cost"] as? [String: Any]) else {
                return nil
        }
        
        self.info = info
        self.cost = cost
    }
}

class ShipmentInfo: Mappable {
    let name: String
    let email: String
    let address: String
    let phone: String
    
    required init?(json: [String : Any]?) {
        guard let name = json?["customer_name"] as? String,
            let email = json?["customer_email"] as? String,
            let address = json?["customer_address"] as? String,
            let phone = json?["customer_phone"] as? String else {
                return nil
        }
        
        self.name = name
        self.email = email
        self.address = address
        self.phone = phone
    }
}

class Buyer: Mappable {
    let name: String
    let email: String
    let phoneNumber: String
    
    required init?(json: [String : Any]?) {
        guard let name = json?["name"] as? String,
            let email = json?["email"] as? String,
            let phoneNumber = json?["phone_number"] as? String else {
                return nil
        }
        
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
    }
}
class Currency: Mappable {
    let currencyCode: String
    let amount: String
    
    required init?(json: [String : Any]?) {
        guard let currencyCode = json?["currency_code"] as? String,
            let amount = json?["amount"] as? String else {
                return nil
        }
        
        self.amount = amount
        self.currencyCode = currencyCode
    }
}
