//
//  InputFormSettings.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/14/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation

public class InputForm: NSObject, NSCoding {
    struct Keys {
        static var show = "show"
        static var required = "required"
    }
    
    var show: Bool
    var required: Bool
    
    init(dict: [String: Any]) {
        self.show = dict[Keys.show] as! Bool
        self.required = dict[Keys.required] as! Bool
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.show = aDecoder.decodeBool(forKey: Keys.show)
        self.required = aDecoder.decodeBool(forKey: Keys.required)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(show, forKey: Keys.show)
        aCoder.encode(required, forKey: Keys.required)
    }
}

public class InputFormSettings: NSObject, NSCoding {
    struct Keys {
        static var enabled = "enabled"
        static var username = "name"
        static var email = "email"
        static var phoneNumber = "phone"
        static var inputFormField = "input_form_field"
        static var inputForm = "input_form"
        static var widget = "widget"
        static var publicData = "public"
    }
    
    var enabled: Bool
    var username: InputForm
    var email: InputForm
    var phoneNumber: InputForm
    
    init?(settings: [String: Any]) {
        guard let publicData = settings[Keys.publicData] as? [String: Any],
            let widget = publicData[Keys.widget] as? [String: Any],
            let formEnabled = widget[Keys.inputForm] as? String,
            let formDict = widget[Keys.inputFormField] as? [String: Any],
            let nameDict = formDict[Keys.username] as? [String: Any],
            let emailDict = formDict[Keys.email] as? [String: Any],
            let phoneDict = formDict[Keys.phoneNumber] as? [String: Any] else { return nil }
        
        enabled = formEnabled == "ENABLED"
        username = InputForm(dict: nameDict)
        email = InputForm(dict: emailDict)
        phoneNumber = InputForm(dict: phoneDict)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.enabled = aDecoder.decodeBool(forKey: Keys.enabled)
        self.username = aDecoder.decodeObject(forKey: Keys.username) as! InputForm
        self.email = aDecoder.decodeObject(forKey: Keys.email) as! InputForm
        self.phoneNumber = aDecoder.decodeObject(forKey: Keys.phoneNumber) as! InputForm
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(enabled, forKey: Keys.enabled)
        aCoder.encode(username, forKey: Keys.username)
        aCoder.encode(email, forKey: Keys.email)
        aCoder.encode(phoneNumber, forKey: Keys.phoneNumber)
    }
}
