//
//  VisitorConnectResponse.swift
//  PrismCoreSDK
//
//  Created by fanni suyuti on 5/19/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

//TODO: some properties might unused, re-check later
open class ConnectResponse : NSObject, Mappable {
    let status: String
    let message: String
    public let mqtt: MQTT
    public let oAuth: OAuth
    public let visitor: Visitor
    let serverTimeStamp: Double
    
    required public init?(dictionary: [String: Any]?) {
        guard let status = dictionary?["status"] as? String,
            let message = dictionary?["message"] as? String,
            let data = dictionary?["data"] as? [String: Any],
            let oAuth = OAuth(dictionary: data["oauth"] as? [String: Any]),
            let mqtt = MQTT(dictionary: data["mqtt"] as? [String: Any]),
            let visitor = Visitor(dictionary: data["visitor"] as? [String: Any]),
            let serverTimeStamp = data["server_timestamp"] as? NSNumber else {
                return nil
        }
        
        self.status = status
        self.message = message
        self.mqtt = mqtt
        self.oAuth = oAuth
        self.visitor = visitor
        self.serverTimeStamp = serverTimeStamp.doubleValue / 1000.0
    }
    
    public func dictionaryValue() -> [String : Any] {
        return ["status": status,
                "message": message,
                "data": ["oauth": oAuth.dictionaryValue(),
                         "mqtt": mqtt.dictionaryValue(),
                         "visitor": visitor.dictionaryValue(),
                         "server_timestamp": serverTimeStamp]]
    }
}
