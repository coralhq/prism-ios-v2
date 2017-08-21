//
//  CDContentInvoice.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/23/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import PrismCore

class CDContentInvoice: ValueTransformer, NSCoding, CDMappable {
    var id: String
    var lineItems: [CDLineItem]
    var grandTotal: CDCurrency
    var buyer: CDBuyer
    var shipment: CDShipment?
    var payment: CDPayment
    
    required init?(dictionary: [String : Any]) {
        let invoice = dictionary["invoice"] as! [String : Any]
        
        id = invoice["id"] as! String
        grandTotal = CDCurrency(dictionary: invoice["grand_total"] as! [String : Any])!
        buyer = CDBuyer(dictionary: invoice["buyer"] as! [String : Any])!
        payment = CDPayment(dictionary: invoice["payment"] as! [String : Any])!
        if let shipment = invoice["shipment"] as? [String : Any] {
            self.shipment = CDShipment(dictionary: shipment)
        }
        lineItems = []
        let items = invoice["line_items"] as! [[String: Any]]
        for item in items {
            lineItems.append(CDLineItem(dictionary: item)!)
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
        
        return ["invoice": invoice]
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
        id = aDecoder.decodeObject(forKey: "id") as! String
        lineItems = aDecoder.decodeObject(forKey: "line_items") as! [CDLineItem]
        grandTotal = aDecoder.decodeObject(forKey: "grand_total") as! CDCurrency
        buyer = aDecoder.decodeObject(forKey: "buyer") as! CDBuyer
        shipment = aDecoder.decodeObject(forKey: "shipment") as? CDShipment
        payment = aDecoder.decodeObject(forKey: "payment") as! CDPayment
    }
}

class CDCurrency: NSObject, NSCoding, CDMappable {
    var currencyCode: String
    var amount: String
    
    required init?(dictionary: [String : Any]) {
        currencyCode = dictionary["currency_code"] as! String
        amount = dictionary["amount"] as! String
    }
    
    public func dictionaryValue() -> [String : Any] {
        return ["currency_code": currencyCode,
                "amount": amount]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(currencyCode, forKey: "currency_code")
        aCoder.encode(amount, forKey: "amount")
    }
    
    required init?(coder aDecoder: NSCoder) {
        currencyCode = aDecoder.decodeObject(forKey: "currency_code") as! String
        amount = aDecoder.decodeObject(forKey: "amount") as! String
    }
}

class CDBuyer: NSObject, NSCoding, CDMappable {
    var name: String
    var email: String
    var phoneNumber: String
    
    required init?(dictionary: [String : Any]) {
        name = dictionary["name"] as! String
        email = dictionary["email"] as! String
        phoneNumber = dictionary["phone_number"] as! String
    }
    
    public func dictionaryValue() -> [String : Any] {
        return ["name": name,
                "email": email,
                "phone_number": phoneNumber]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(phoneNumber, forKey: "phone_number")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        email = aDecoder.decodeObject(forKey: "email") as! String
        phoneNumber = aDecoder.decodeObject(forKey: "phone_number") as!
        String
    }
}

class CDShipment: NSObject, NSCoding, CDMappable {
    var info: CDShipmentInfo
    var cost: CDCurrency
    
    required init?(dictionary: [String : Any]) {
        info = CDShipmentInfo(dictionary: dictionary["info"] as! [String: Any])!
        cost = CDCurrency(dictionary: dictionary["cost"] as! [String: Any])!
    }
    
    public func dictionaryValue() -> [String : Any] {
        return ["info": info.dictionaryValue(),
                "cost": cost.dictionaryValue()]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(info, forKey: "info")
        aCoder.encode(cost, forKey: "cost")
    }
    
    required init?(coder aDecoder: NSCoder) {
        info = aDecoder.decodeObject(forKey: "info") as! CDShipmentInfo
        cost = aDecoder.decodeObject(forKey: "cost") as! CDCurrency
    }
}

class CDShipmentInfo: NSObject, NSCoding, CDMappable {
    var name: String
    var email: String
    var address: String
    var phone: String
    
    required init?(dictionary: [String : Any]) {
        name = dictionary["customer_name"] as! String
        email = dictionary["customer_email"] as! String
        address = dictionary["customer_address"] as! String
        phone = dictionary["customer_phone"] as! String
    }
    
    func dictionaryValue() -> [String : Any] {
        return ["customer_name": name,
                "customer_email": email,
                "customer_address": address,
                "customer_phone": phone]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(phone, forKey: "phone")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        email = aDecoder.decodeObject(forKey: "email") as! String
        address = aDecoder.decodeObject(forKey: "address") as! String
        phone = aDecoder.decodeObject(forKey: "phone") as! String
    }
}

class CDPayment: NSObject, NSCoding, CDMappable {
    var provider: CDPaymentProvider
    
    required init?(dictionary: [String : Any]) {
        let provider = dictionary["provider"] as! [String: Any]
        self.provider = CDPaymentProvider(dictionary: provider)!
    }
    
    func dictionaryValue() -> [String : Any] {
        return ["provider": provider.dictionaryValue()]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(provider, forKey: "provider")
    }
    
    required init?(coder aDecoder: NSCoder) {
        provider = aDecoder.decodeObject(forKey: "provider") as! CDPaymentProvider
    }
}

class CDPaymentProvider: NSObject, NSCoding, CDMappable {
    var type: String
    var info: CDMappable?
    
    required init?(dictionary: [String : Any]) {
        type = dictionary["type"] as! String
        
        if let info = dictionary["info"] as? [String: Any] {
            self.info = CDMidtransInfo(dictionary: info)
        } else if let transfer = dictionary["transfer"] as? [String: Any] {
            self.info = CDBankTransferInfo(dictionary: transfer)
        }
    }
    func dictionaryValue() -> [String : Any] {
        var result: [String: Any] = ["type": type]
        guard let info = info else {
            return result
        }
        if type == "vt_web" {
            result["info"] = info.dictionaryValue()
        } else if type == "transfer" {
            result["transfer"] = info.dictionaryValue()
        }
        return result
    }
    
    required init?(coder aDecoder: NSCoder) {
        type = aDecoder.decodeObject(forKey: "type") as! String
        info = aDecoder.decodeObject(forKey: "info") as? CDMappable
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(type, forKey: "type")
        aCoder.encode(info, forKey: "info")
    }
}

class CDMidtransInfo: NSObject, NSCoding, CDMappable {
    var redirectURL: String
    
    required init?(dictionary: [String : Any]) {
        redirectURL = dictionary["redirect_url"] as! String
    }
    
    func dictionaryValue() -> [String : Any] {
        return ["redirect_url": redirectURL]
    }
    
    required init?(coder aDecoder: NSCoder) {
        redirectURL = aDecoder.decodeObject(forKey: "redirect_url") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(redirectURL, forKey: "redirect_url")
    }
}

class CDBankTransferInfo: NSObject, NSCoding, CDMappable {
    var accountNumber: String
    var accountHolder: String
    var bankName: String
    
    required init?(dictionary: [String : Any]) {
        accountHolder = dictionary["account_holder"] as! String
        accountNumber = dictionary["account_number"] as! String
        bankName = dictionary["bank_name"] as! String
    }
    func dictionaryValue() -> [String : Any] {
        return ["account_number": accountNumber,
                "account_holder": accountHolder,
                "bank_name": bankName]
    }
    
    required init?(coder aDecoder: NSCoder) {
        accountNumber = aDecoder.decodeObject(forKey: "account_number") as! String
        accountHolder = aDecoder.decodeObject(forKey: "account_holder") as! String
        bankName = aDecoder.decodeObject(forKey: "bank_name") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(accountNumber, forKey: "account_number")
        aCoder.encode(accountHolder, forKey: "account_holder")
        aCoder.encode(bankName, forKey: "bank_name")
    }
}
