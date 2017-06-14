//
//  PrismCredential.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/14/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import PrismCore

class PrismCredential: NSObject, NSCoding {
    struct Keys {
        static var username = "username"
        static var password = "password"
    }
    
    var username: String
    var password: String
    
    init(connectResponse: ConnectResponse) {
        username = connectResponse.mqtt.username
        password = connectResponse.mqtt.password
    }
    
    public required init?(coder aDecoder: NSCoder) {
        username = aDecoder.decodeObject(forKey: Keys.username) as! String
        password = aDecoder.decodeObject(forKey: Keys.password) as! String
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(username, forKey: Keys.username)
        aCoder.encode(password, forKey: Keys.password)
    }
}
