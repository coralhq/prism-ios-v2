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
    public let shipment: Shipment?
    public let notes: String?
    
    required public init?(dictionary: [String : Any]?) {
        
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
        
        self.notes = invoice["notes"] as? String
        self.id = id
        self.lineItems = lineItems
        self.grandTotal = grandTotal
        self.buyer = buyer
        self.payment = payment
        
        if let shipmentDict = invoice["shipment"] as? [String: Any] {
            self.shipment = Shipment(dictionary: shipmentDict)
        } else {
            self.shipment = nil
        }
    }
    
    public func dictionaryValue() -> [String : Any] {
        var items: [[String: Any]] = []
        for item in lineItems {
            items.append(item.dictionaryValue())
        }
        
        var invoice: [String: Any] = ["id": id,
                                      "line_items": items,
                                      "grand_total": grandTotal.dictionaryValue(),
                                      "buyer": buyer.dictionaryValue(),
                                      "payment": payment.dictionaryValue()]
        
        if let shipment = shipment {
            invoice["shipment"] = shipment.dictionaryValue()
        }
        
        if let notes = notes {
            invoice["notes"] = notes
        }
        
        return ["invoice": invoice]
    }
}

public class Payment: Mappable {
    public let provider: PaymentProvider
    
    required public init?(dictionary: [String : Any]?) {
        guard let providerDictionary = dictionary?["provider"] as? [String: Any],
            let provider = PaymentProvider(dictionary: providerDictionary) else {
                return nil
        }
        self.provider = provider
    }
    
    public func dictionaryValue() -> [String : Any] {
        return ["provider": provider.dictionaryValue()]
    }
}

public class PaymentProvider: Mappable {
    public let type: String
    public let info: Mappable?
    
    public required init?(dictionary: [String : Any]?) {
        guard let type = dictionary?["type"] as? String,
            let infoDictionary = dictionary?[type] as? [String: Any] else {
                return nil
        }
        self.type = type
        
        if type == "vt_web" {
            self.info = MidtransInfo(dictionary: infoDictionary)
        } else if type == "transfer" {
            self.info = BankTransferInfo(dictionary: infoDictionary)
        } else if type == "payment_link" {
            self.info = PaymentLinkInfo(dictionary: infoDictionary)
        } else {
            self.info = nil
        }
    }
    
    public func dictionaryValue() -> [String : Any] {
        var result: [String: Any] = ["type": type]
        guard let info = info else {
            return result
        }
        result[type] = info.dictionaryValue()
        return result
    }
}

class PaymentLink: Mappable {
    public let id: String
    public let label: String
    public let url: String
    
    required init?(dictionary: [String : Any]?) {
        guard let dictionary = dictionary,
            let id = dictionary["id"] as? String,
            let label = dictionary["label"] as? String,
            let url = dictionary["url"] as? String else {
                return nil
        }
        self.id = id
        self.label = label
        self.url = url
    }
    
    func dictionaryValue() -> [String : Any] {
        return [
            "id": id,
            "label": label,
            "url": url
        ]
    }
}

class PaymentLinkInfo: Mappable {
    public let type: String
    public let link: PaymentLink
    
    required init?(dictionary: [String : Any]?) {
        guard let dictionary = dictionary,
            let type = dictionary["type"] as? String,
            let linkDictionary = dictionary["payment_link"] as? [String: Any],
            let link = PaymentLink(dictionary: linkDictionary) else {
                return nil
        }
        self.type = type
        self.link = link
    }
    
    func dictionaryValue() -> [String : Any] {
        return [
            "type": type,
            "payment_link": link.dictionaryValue()
        ]
    }
}

class MidtransInfo: Mappable {
    public let redirectURL: String
    
    required init?(dictionary: [String : Any]?) {
        guard let redirectURL = dictionary?["redirect_url"] as? String else {
            return nil
        }
        self.redirectURL = redirectURL
    }
    
    func dictionaryValue() -> [String : Any] {
        return ["redirect_url": redirectURL]
    }
}

class BankTransferInfo: Mappable {
    public let accountNumber: String
    public let accountHolder: String
    public let bankName: String
    
    required init?(dictionary: [String : Any]?) {
        guard let accNumber = dictionary?["account_number"] as? String,
            let accHolder = dictionary?["account_holder"] as? String,
            let bankName = dictionary?["bank_name"] as? String else {
                return nil
        }
        self.accountNumber = accNumber
        self.accountHolder = accHolder
        self.bankName = bankName
    }
    func dictionaryValue() -> [String : Any] {
        return ["account_number": accountNumber,
                "account_holder": accountHolder,
                "bank_name": bankName]
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
    
    public func dictionaryValue() -> [String : Any] {
        return ["info": info.dictionaryValue(),
                "cost": cost.dictionaryValue()]
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
    
    public func dictionaryValue() -> [String : Any] {
        return ["customer_name": name,
                "customer_email": email,
                "customer_address": address,
                "customer_phone": phone]
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
    
    public func dictionaryValue() -> [String : Any] {
        return ["name": name,
                "email": email,
                "phone_number": phoneNumber]
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
    
    public func dictionaryValue() -> [String : Any] {
        return ["currency_code": currencyCode,
                "amount": amount]
    }
}
