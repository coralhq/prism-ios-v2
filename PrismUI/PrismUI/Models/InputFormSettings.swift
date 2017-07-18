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
    
    let show: Bool
    let required: Bool
    
    public override init() {
        self.show = false
        self.required = false
    }
    
    init(settings: [String: Any]) {
        if let show = settings[Keys.show] as? Bool,
            let required = settings[Keys.required] as? Bool {
            self.show = show
            self.required = required
        } else {
            self.show = false
            self.required = false
        }
        super.init()
    }
}

class OfflineForm {
    let show: Bool
    init(option: [String: Any]?) {
        if let option = option?["show"] as? Bool {
            show = option
        } else {
            show = false
        }
    }
}

class OfflineFormSettings {
    var email: OfflineForm
    var name: OfflineForm
    
    init() {
        email = OfflineForm(option: nil)
        name = OfflineForm(option: nil)
    }
    
    func configure(settings: [String: Any]) {
        if let widget = settings["widget"] as? [String: Any],
            let offlineMessage = widget["offline_widget"] as? [String: Any],
            let formOptions = offlineMessage["form_options"] as? [String: Any],
            let emailOption = formOptions["email"] as? [String: Any],
            let nameOption = formOptions["name"] as? [String: Any] {
            email = OfflineForm(option: emailOption)
            name = OfflineForm(option: nameOption)
        }
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

    func configure(settings: [String: Any]) {
        if let widget = settings[Keys.widget] as? [String: Any],
            let formEnabled = widget[Keys.inputForm] as? String,
            let formField = widget[Keys.inputFormField] as? [String: Any],
            let nameDict = formField[Keys.username] as? [String: Any],
            let emailDict = formField[Keys.email] as? [String: Any],
            let phoneDict = formField[Keys.phoneNumber] as? [String: Any] {
            
            self.enabled = formEnabled == "ENABLED"
            self.username = InputForm(settings: nameDict)
            self.email = InputForm(settings: emailDict)
            self.phoneNumber = InputForm(settings: phoneDict)            
        }
    }
}
