//
//  Visitor.swift
//  PrismCoreSDK
//
//  Created by fanni suyuti on 5/19/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

//TODO: some properties might unused, re-check later
public class Visitor : Mappable {
    public let id: String
    public let name: String
    public let merchantID: String
    public let appName: String
    public let channelName: String
    public let channelUserID: String
    
    required public init?(json: [String: Any]?) {
        guard let id = json?["id"] as? String,
            let name = json?["name"] as? String,
            let merchantID = json?["merchant_id"] as? String,
            let appName = json?["app_name"] as? String,
            let channelName = json?["channel_name"] as? String,
            let channelUserID = json?["channel_user_id"] as? String
            else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.merchantID = merchantID
        self.appName = appName
        self.channelName = channelName
        self.channelUserID = channelUserID
    }
    
}
