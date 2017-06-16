//
//  InputFormSettings.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/14/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation

public class InputForm: NSObject {
    struct Keys {
        static var show = "show"
        static var required = "required"
    }
    
    var show: Bool = false
    var required: Bool = false
    var settings: [String: Any]? {
        didSet {
            guard let settings = settings,
                let show = settings[Keys.show] as? Bool,
                let required = settings[Keys.required] as? Bool else { return }
            self.show = show
            self.required = required
        }
    }
    
    public override init() {
        
    }
}

public class InputFormSettings: NSObject {
    struct Keys {
        static var enabled = "enabled"
        static var username = "name"
        static var email = "email"
        static var phoneNumber = "phone"
        static var inputFormField = "input_form_field"
        static var inputForm = "input_form"
        static var widget = "widget"
    }
    
    var enabled: Bool
    var username: InputForm
    var email: InputForm
    var phoneNumber: InputForm
    
    public override init() {
        enabled = false
        username = InputForm()
        email = InputForm()
        phoneNumber = InputForm()
    }
    
    var settings: [String: Any]? {
        didSet {
            guard let widget = settings?[Keys.widget] as? [String: Any],
                let formEnabled = widget[Keys.inputForm] as? String,
                let formField = widget[Keys.inputFormField] as? [String: Any],
                let nameDict = formField[Keys.username] as? [String: Any],
                let emailDict = formField[Keys.email] as? [String: Any],
                let phoneDict = formField[Keys.phoneNumber] as? [String: Any] else { return }
            
            enabled = formEnabled == "ENABLED"
            username.settings = nameDict
            email.settings = emailDict
            phoneNumber.settings = phoneDict
        }
    }
}
