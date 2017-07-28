//
//  AuthViewModel.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/16/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import PrismCore

struct SerialisationKeys {
    static let setting = "prism_settings"
    static let credential = "prism_credential"
}

let ConnectNotification = NSNotification.Name(rawValue: "ConnectNotification")
let DisconnectNotification = NSNotification.Name(rawValue: "DisconnectNotification")

public class AuthViewModel {
    
    func visitorConnectAnonymous(completion: @escaping (NSError?) -> Void) {
        PrismCore.shared.annonymousVisitorConnect { [weak self] (connect, error) in
            self?.handle(connect: connect, error: error, completion: completion)
        }
    }
    
    func visitorConnect(name: String?, email: String?, phoneNumber: String?, completion: @escaping (NSError?) -> Void) {
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
        
        PrismCore.shared.visitorConnect(userName: userName, userID: userID) { [weak self] (connect, error) in
            self?.handle(connect: connect, error: error, completion: completion)
        }
    }
    
    func getSettings(completion: @escaping ([String: Any]?) -> ()) {
        let currentSettings: [String: Any]? = Utils.unarchive(key: SerialisationKeys.setting)
        
        var isConfigured = false
        
        if let settings = currentSettings {
            Settings.shared.configure(settings: settings)
            completion(settings)
            isConfigured = true
        }
        
        PrismCore.shared.getSettings { (settings, error) in
            guard let settings = settings?["public"] as? [String: Any] else {
                completion(nil)
                return
            }
            
            if settings.isEqual(to: currentSettings) == false {
                Utils.archive(object: settings, key: SerialisationKeys.setting)
            }
            
            Settings.shared.configure(settings: settings)
            
            if isConfigured == false {
                completion(settings)
            }
            
            isConfigured = true
        }
    }
}

extension AuthViewModel {
    func handle(connect: ConnectResponse?, error: NSError?, completion: @escaping (NSError?) -> Void) {
        guard let connect = connect else { return }
        
        PrismCore.shared.createConversation(visitorName: connect.visitor.name, token: connect.oAuth.accessToken, completionHandler: { (conversation, error) in
            guard let conversation = conversation else { return }
            
            if let error = error {
                completion(error)
            } else {
                let credential = PrismCredential()
                credential.configure(connect: connect, conversation: conversation)
                Vendor.shared.credential = credential
                completion(nil)
            }
        })
    }
}
