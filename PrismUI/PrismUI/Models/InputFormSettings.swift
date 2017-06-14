//
//  InputFormSettings.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/14/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation

public class InputForm: NSObject {
    var show: Bool
    var required: Bool
    
    init(dict: [String: Any]) {
        self.show = dict["show"] as! Bool
        self.required = dict["required"] as! Bool
    }
}

public class InputFormSettings: NSObject {
    var enabled: Bool
    var username: InputForm
    var email: InputForm
    var phoneNumber: InputForm
    
    init?(settings: [String: Any]) {
        guard let publicData = settings["public"] as? [String: Any],
            let widget = publicData["widget"] as? [String: Any],
            let formEnabled = widget["input_form"] as? String,
            let formDict = widget["input_form_field"] as? [String: Any],
            let nameDict = formDict["name"] as? [String: Any],
            let emailDict = formDict["email"] as? [String: Any],
            let phoneDict = formDict["phone"] as? [String: Any] else { return nil }
        
        enabled = formEnabled == "ENABLED"
        username = InputForm(dict: nameDict)
        email = InputForm(dict: emailDict)
        phoneNumber = InputForm(dict: phoneDict)
    }
}
