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
    
    var _credential: PrismCredential?
    var credential: PrismCredential? {
        set {
            guard let credential = newValue else {
                Utils.removeArchive(key: SerialisationKeys.credential); return
            }
            Utils.archive(object: credential, key: SerialisationKeys.credential)
            _credential = credential
        }
        get {
            if _credential == nil {
                _credential = Utils.unarchive(key: SerialisationKeys.credential) as? PrismCredential
            }
            return _credential
        }
    }
    
    func visitorConnectAnonymous(completion: @escaping (PrismCredential?, NSError?) -> Void) {
        PrismCore.shared.annonymousVisitorConnect { [weak self] (connect, error) in
            self?.handle(connect: connect, error: error, completion: completion)
        }
    }
    
    func visitorConnect(name: String?, email: String?, phoneNumber: String?, completion: @escaping (PrismCredential?, NSError?) -> Void) {
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
    
    func getSettings(completion: @escaping ([String: Any]) -> ()) {
        if let settings = UserDefaults.standard.value(forKey: SerialisationKeys.setting) as? [String: Any] {
            completion(settings)
        } else {
            PrismCore.shared.getSettings { (settings, error) in
                guard error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                
                guard let settings = settings?["public"] as? [String: Any] else { return }
                
                UserDefaults.standard.set(settings, forKey: SerialisationKeys.setting)
                
                completion(settings)
            }
        }
    }
}


extension AuthViewModel {
    func handle(connect: ConnectResponse?, error: NSError?, completion: @escaping (PrismCredential?, NSError?) -> Void) {
        guard let connect = connect else { return }
        
        PrismCore.shared.createConversation(visitorName: connect.visitor.name, token: connect.oAuth.accessToken, completionHandler: { (conversation, error) in
            guard let conversation = conversation else { return }
            
            if let error = error {
                completion(nil, error)
            } else {
                let credential = PrismCredential(connect: connect, conversation: conversation)
                
                //save credential
                Utils.archive(object: credential, key: SerialisationKeys.credential)
                
                completion(credential, nil)
            }
        })
    }
}
