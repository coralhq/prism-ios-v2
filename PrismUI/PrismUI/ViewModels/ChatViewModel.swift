//
//  ChatViewModel.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/16/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import PrismCore

class ChatViewModel {
    var credential: PrismCredential
    
    init(credential: PrismCredential) {
        self.credential = credential
    }
    
    func connect(completionHandler: @escaping ((Bool, Error?) -> ())) {
        PrismCore.shared.connectToBroker(username: credential.username, password: credential.password) { (success, error) in
            completionHandler(success, error)
        }
    }
    
    func subscribe(completionHandler: @escaping ((Bool, Error?) -> ())) {
        PrismCore.shared.subscribeToTopic(credential.topic) { (success, error) in
            completionHandler(success, error)
        }
    }
}
