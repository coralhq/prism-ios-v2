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
        static var conversationID = "conversation_id"
        static var merchantID = "merchant_id"
        static var visitor = "visitor"
        static var sender = "sender"
        static var refreshToken = "refresh_token"
        static var clientID = "client_id"
    }
    
    var username: String = ""
    var password: String = ""
    var visitorName: String = ""
    var accessToken: String = ""
    var refreshToken: String = ""
    var topic: String = ""
    var conversationID: String = ""
    var merchantID: String = ""
    var visitorInfo: MessageUser = MessageUser(id: "", name: "")!
    var sender: MessageSender = MessageSender(id: "", name: "", role: "", userAgent: "")!
    var clientID: String = ""
    
    static var shared = PrismCredential()
    
    private override init() {}
    
    public required init?(coder aDecoder: NSCoder) {
        username = aDecoder.decodeObject(forKey: Keys.username) as! String
        password = aDecoder.decodeObject(forKey: Keys.password) as! String
        visitorName = aDecoder.decodeObject(forKey: Keys.visitorName) as! String
        accessToken = aDecoder.decodeObject(forKey: Keys.accessToken) as! String
        topic = aDecoder.decodeObject(forKey: Keys.topic) as! String
        conversationID = aDecoder.decodeObject(forKey: Keys.conversationID) as! String
        merchantID = aDecoder.decodeObject(forKey: Keys.merchantID) as! String
        refreshToken = aDecoder.decodeObject(forKey: Keys.refreshToken) as! String
        clientID = aDecoder.decodeObject(forKey: Keys.clientID) as! String
        
        let visitorDict = aDecoder.decodeObject(forKey: Keys.visitor) as! [String: Any]
        visitorInfo = MessageUser(dictionary: visitorDict)!
        
        let senderDict = aDecoder.decodeObject(forKey: Keys.sender) as! [String: Any]
        sender = MessageSender(dictionary: senderDict)!
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(username, forKey: Keys.username)
        aCoder.encode(password, forKey: Keys.password)
        aCoder.encode(visitorName, forKey: Keys.visitorName)
        aCoder.encode(accessToken, forKey: Keys.accessToken)
        aCoder.encode(topic, forKey: Keys.topic)
        aCoder.encode(conversationID, forKey: Keys.conversationID)
        aCoder.encode(merchantID, forKey: Keys.merchantID)
        aCoder.encode(visitorInfo.dictionaryValue(), forKey: Keys.visitor)
        aCoder.encode(sender.dictionaryValue(), forKey: Keys.sender)
        aCoder.encode(refreshToken, forKey: Keys.refreshToken)
        aCoder.encode(clientID, forKey: Keys.clientID)
    }
    
    func configure(connect: ConnectResponse, conversation: CreateConversationResponse) {
        username = connect.mqtt.username
        password = connect.mqtt.password
        visitorName = connect.visitor.name
        accessToken = connect.oAuth.accessToken
        refreshToken = connect.oAuth.refreshToken
        topic = conversation.conversation.topic
        conversationID = conversation.conversation.id
        merchantID = connect.visitor.merchantID
        clientID = connect.oAuth.clientID
        
        visitorInfo = MessageUser(id: connect.visitor.id, name: connect.visitor.name)!
        sender = MessageSender(id: connect.visitor.id, name: connect.visitor.name, role: "visitor", userAgent: "iOSSDK-v1.0.0")!
    }
}
