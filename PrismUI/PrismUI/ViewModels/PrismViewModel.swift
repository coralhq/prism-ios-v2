//
//  AuthViewModel.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/14/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import PrismCore

struct SerialisationKeys {
    static let setting = "prism_settings"
    static let credential = "prism_credential"
}

let ConnectNotification = NSNotification.Name(rawValue: "ConnectNotification")
let DisconnectNotification = NSNotification.Name(rawValue: "DisconnectNotification")

class PrismViewModel {
    func getInputFormSettings(completion: @escaping (_ settings: InputFormSettings?, _ error: NSError?) -> Void) {
        if let settings = Utils.unarchive(key: SerialisationKeys.setting) as? InputFormSettings  {
            completion(settings, nil)
        } else {
            PrismCore.shared.getSettings(completionHandler: { (settings, error) in
                if let error = error as NSError? {
                    completion(nil, error)
                } else {
                    guard let settingsDict = settings,
                        let settings = InputFormSettings(settings: settingsDict) else { return }
                    
                    Utils.archive(object: settings, key: SerialisationKeys.setting)
                    completion(settings, nil)
                }
            })
        }
    }
    
    func connect(name: String?, email: String?, phoneNumber: String?, completion: @escaping (_ credential: PrismCredential?, _ error: NSError?) -> Void) {
        
        var userID: String {
            get {
                if let email = email,
                    let phone = phoneNumber,
                    email.characters.count > 0,
                    phone.characters.count > 0 {
                    return "\(email);\(phone)"
                } else if let email = email,
                    email.characters.count > 0 {
                    return email
                } else if let phone = phoneNumber,
                    phone.characters.count > 0 {
                    return phone
                } else {
                    return ""
                }
            }
        }
        
        var userName: String {
            get {
                if let name = name {
                    return name
                } else {
                    return ""
                }
            }
        }
        
        PrismCore.shared.visitorConnect(userName: userName, userID: userID) { (response, error) in
            if let error = error {
                completion(nil, error)
            } else if let response = response {
                let credential = PrismCredential(connectResponse: response)
                Utils.archive(object: credential, key: SerialisationKeys.credential)
                completion(credential, nil)
            }
        }
    }
    
    var credential: PrismCredential? {
        return Utils.unarchive(key: SerialisationKeys.credential) as? PrismCredential
    }
}
