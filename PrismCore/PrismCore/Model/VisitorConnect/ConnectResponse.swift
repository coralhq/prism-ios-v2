//
//  VisitorConnectResponse.swift
//  PrismCoreSDK
//
//  Created by fanni suyuti on 5/19/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

//TODO: some properties might unused, re-check later
public class ConnectResponse : Mappable {
    let status: String
    let message: String
    public let mqtt: MQTT
    public let oAuth: OAuth
    public let visitor: Visitor
    let serverTimeStamp: Double
    
    required public init?(json: [String: Any]?) {
        guard let status = json?["status"] as? String,
            let message = json?["message"] as? String,
            let data = json?["data"] as? [String: Any],
            let oAuth = OAuth(json: data["oauth"] as? [String: Any]),
            let mqtt = MQTT(json: data["mqtt"] as? [String: Any]),
            let visitor = Visitor(json: data["visitor"] as? [String: Any]),
            let serverTimeStamp = data["server_timestamp"] as? Double
            else {
                return nil
        }
        
        self.status = status
        self.message = message
        self.mqtt = mqtt
        self.oAuth = oAuth
        self.visitor = visitor
        self.serverTimeStamp = serverTimeStamp
    }
}
