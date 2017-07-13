//
//  ContentInvoice.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

public class ContentInvoice: MessageContentMappable {
    
    public let id: String
    public let lineItems: [LineItem]
    public let grandTotal: Currency
    public let buyer: Buyer
    public let payment: Payment
    public var shipment: Shipment?
    
    var dictionary: [String: Any]?
    
    required public init?(dictionary: [String : Any]?) {
        self.dictionary = dictionary
        
        guard let invoice = dictionary?["invoice"] as? [String: Any],
            let id = invoice["id"] as? String,
            let lineItemDictionaries = invoice["line_items"] as? [[String: Any]],
            let grandTotal = Currency(dictionary: invoice["grand_total"] as? [String: Any]),
            let buyer = Buyer(dictionary: invoice["buyer"] as? [String: Any]),
            let payment = Payment(dictionary: invoice["payment"] as? [String: Any]) else { return nil }
        
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
        self.payment = payment
        
        if let shipmentDict = invoice["shipment"] as? [String: Any] {
            self.shipment = Shipment(dictionary: shipmentDict)
        }
    }
    
    public func dictionaryValue() -> [String : Any]? {
        return dictionary
    }
}

public class Payment: Mappable {
    public let type: String
    public var midtransPaymentURL: URL?
    
    required public init?(dictionary: [String : Any]?) {
        guard let provider = dictionary?["provider"] as? [String: Any],
            let type = provider["type"] as? String else {
                return nil
        }
        self.type = type
        
        if let vtweb = provider["vt_web"] as? [String: Any],
            let stringURL = vtweb["redirect_url"] as? String,
            let redirectURL = URL(string: stringURL) {
            self.midtransPaymentURL = redirectURL
        }
    }
}

public class Shipment: Mappable {
    public let info: ShipmentInfo
    public let cost: Currency
    
    required public init?(dictionary: [String : Any]?) {
        guard let info = ShipmentInfo(dictionary: dictionary?["info"] as? [String: Any]),
            let cost = Currency(dictionary: dictionary?["cost"] as? [String: Any]) else {
                return nil
        }
        
        self.info = info
        self.cost = cost
    }
}

public class ShipmentInfo: Mappable {
    public let name: String
    public let email: String
    public let address: String
    public let phone: String
    
    required public init?(dictionary: [String : Any]?) {
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

public class Buyer: Mappable {
    public let name: String
    public let email: String
    public let phoneNumber: String
    
    required public init?(dictionary: [String : Any]?) {
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
public class Currency: Mappable {
    public let currencyCode: String
    public let amount: String
    
    required public init?(dictionary: [String : Any]?) {
        guard let currencyCode = dictionary?["currency_code"] as? String,
            let amount = dictionary?["amount"] as? String else {
                return nil
        }
        
        self.amount = amount
        self.currencyCode = currencyCode
    }
}
