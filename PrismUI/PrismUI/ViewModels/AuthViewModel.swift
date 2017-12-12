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

class AuthViewModel {
    
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
                    email.count > 0,
                    phone.count > 0 {
                    return "\(email);\(phone)"
                } else if let email = email,
                    email.count > 0 {
                    return email
                } else if let phone = phoneNumber,
                    phone.count > 0 {
                    return phone
                } else {
                    return NSUUID().uuidString
                }
            }
        }
        
        var userName: String {
            get {
                if let name = name,
                    name.count > 0 {
                    return name
                } else {
                    return "visitor_\(String.randomString(length: 7))"
                }
            }
        }
        
        PrismCore.shared.visitorConnect(userName: userName, userID: userID) { [weak self] (connect, error) in
            self?.handle(connect: connect, error: error, completion: completion)
        }
    }
    
    func visitorConnect(completion: @escaping (NSError?) -> Void) {
        guard let credential = Vendor.shared.credential else {
            completion(nil)
            return
        }
        
        PrismCore.shared.visitorConnect(userName: credential.channelName, userID: credential.channelID) { [weak self] (connect, error) in
            
            DispatchQueue.main.async {
                guard let `self` = self else {
                    completion(NSError(domain: "", code: 1, userInfo: nil))
                    return
                }
                
                self.handle(connect: connect, error: error, completion: completion)
            }
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
                completion(currentSettings)
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
        if error != nil {
            completion(error)
            return
        }
        
        guard let connect = connect else {
            return
        }
        
        PrismCore.shared.createConversation(visitorName: connect.visitor.name, token: connect.oAuth.accessToken, completionHandler: { (conversation, error) in
            DispatchQueue.main.async {
                guard let conversation = conversation else { return }
                
                if let error = error {
                    completion(error)
                } else {
                    let credential = PrismCredential()
                    credential.configure(connect: connect, conversation: conversation)
                    Vendor.shared.credential = credential
                    completion(nil)
                }
            }
        })
    }
}
