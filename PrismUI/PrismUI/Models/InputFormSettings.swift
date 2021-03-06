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

class OfflineFormSettings {
    var email: InputForm
    var name: InputForm
    var phone: InputForm
    
    init() {
        email = InputForm()
        name = InputForm()
        phone = InputForm()
    }
    
    func configure(settings: [String: Any]) {
        print("SETTINGS: \(settings)")
        if let widget = settings["widget"] as? [String: Any],
            let offlineMessage = widget["offline_widget"] as? [String: Any],
            let formOptions = offlineMessage["form_options"] as? [String: Any],
            let emailOption = formOptions["email"] as? [String: Any],
            let nameOption = formOptions["name"] as? [String: Any],
            let phoneOption = formOptions["phone"] as? [String: Any] {
            email = InputForm(settings: emailOption)
            name = InputForm(settings: nameOption)
            phone = InputForm(settings: phoneOption)
        }
    }
}

public class InputFormSettings: NSObject {
    var message: String?
    var enabled: Bool
    var username: InputForm
    var email: InputForm
    var phoneNumber: InputForm
    
    public override init() {
        message = ""
        enabled = false
        username = InputForm()
        email = InputForm()
        phoneNumber = InputForm()
    }
    
    func configure(settings: [String: Any]) {
        
        if let widget = settings["widget"] as? [String: Any],
            let visitorConnect = widget["visitor_connect"] as? [String: Any],
            let formEnabled = visitorConnect["option"] as? String,
            let formField = visitorConnect["form_options"] as? [String: Any],
            let nameDict = formField["name"] as? [String: Any],
            let emailDict = formField["email"] as? [String: Any],
            let phoneDict = formField["phone"] as? [String: Any] {
            
            self.enabled = formEnabled == "ENABLED"
            self.username = InputForm(settings: nameDict)
            self.email = InputForm(settings: emailDict)
            self.phoneNumber = InputForm(settings: phoneDict)
            self.message = visitorConnect["form_message"] as? String
        }
    }
}
