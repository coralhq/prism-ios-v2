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
        static var visitorName = "visitor_name"
        static var accessToken = "access_token"
        static var topic = "topic"
    }
    
    var username: String
    var password: String
    var visitorName: String
    var accessToken: String
    var topic: String
    
    init(connect: ConnectResponse, conversation: CreateConversationResponse) {
        username = connect.mqtt.username
        password = connect.mqtt.password
        visitorName = connect.visitor.name
        accessToken = connect.oAuth.accessToken
        topic = conversation.conversation.topic
    }
    
    public required init?(coder aDecoder: NSCoder) {
        username = aDecoder.decodeObject(forKey: Keys.username) as! String
        password = aDecoder.decodeObject(forKey: Keys.password) as! String
        visitorName = aDecoder.decodeObject(forKey: Keys.visitorName) as! String
        accessToken = aDecoder.decodeObject(forKey: Keys.accessToken) as! String
        topic = aDecoder.decodeObject(forKey: Keys.topic) as! String
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(username, forKey: Keys.username)
        aCoder.encode(password, forKey: Keys.password)
        aCoder.encode(visitorName, forKey: Keys.visitorName)
        aCoder.encode(accessToken, forKey: Keys.accessToken)
        aCoder.encode(topic, forKey: Keys.topic)
    }
}
