//
//  PrismCredential.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/14/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import PrismCore

class PrismCredential: NSObject {
    var username: String
    var password: String
    
    init(connectResponse: ConnectResponse) {
        username = connectResponse.mqtt.username
        password = connectResponse.mqtt.password
    }
}
