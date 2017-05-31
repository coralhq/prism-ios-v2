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
    
    required init?(dictionary: [String : Any]?) {
        guard let id = dictionary?["id"] as? String,
            let lineItemDictionaries = dictionary?["line_items"] as? [[String: Any]],
            let grandTotal = Currency(dictionary: dictionary?["grand_total"] as? [String: Any]),
            let buyer = Buyer(dictionary: dictionary?["buyer"] as? [String: Any]),
            let shipment = Shipment(dictionary: dictionary?["shipment"] as? [String: Any]),
            let payment = Payment(dictionary: dictionary?["paument"] as? [String: Any]) else {
                return nil
        }
        
        var lineItems = [LineItem]()
        for dictionary in lineItemDictionaries {
            guard let lineItem = LineItem(dictionary: dictionary) else {
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
    
    required init?(dictionary: [String : Any]?) {
        guard let provider = dictionary?["provider"] as? [String: Any],
            let type = provider["type"] as? String else {
                return nil
        }
        
        self.type = type
    }
}

class Shipment: Mappable {
    let info: ShipmentInfo
    let cost: Currency
    
    required init?(dictionary: [String : Any]?) {
        guard let info = ShipmentInfo(dictionary: dictionary?["info"] as? [String: Any]),
            let cost = Currency(dictionary: dictionary?["cost"] as? [String: Any]) else {
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
    
    required init?(dictionary: [String : Any]?) {
        guard let name = dictionary?["customer_name"] as? String,
            let email = dictionary?["customer_email"] as? String,
            let address = dictionary?["customer_address"] as? String,
            let phone = dictionary?["customer_phone"] as? String else {
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
    
    required init?(dictionary: [String : Any]?) {
        guard let name = dictionary?["name"] as? String,
            let email = dictionary?["email"] as? String,
            let phoneNumber = dictionary?["phone_number"] as? String else {
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
    
    required init?(dictionary: [String : Any]?) {
        guard let currencyCode = dictionary?["currency_code"] as? String,
            let amount = dictionary?["amount"] as? String else {
                return nil
        }
        
        self.amount = amount
        self.currencyCode = currencyCode
    }
}
