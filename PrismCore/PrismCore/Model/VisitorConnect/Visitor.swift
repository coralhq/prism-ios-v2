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
    public var id: String
    public var name: String
    public var merchantID: String
    public var appName: String
    public var channelName: String
    public var channelUserID: String
    
    required public init?(dictionary: [String: Any]?) {
        guard let id = dictionary?["id"] as? String,
            let name = dictionary?["name"] as? String,
            let merchantID = dictionary?["merchant_id"] as? String,
            let appName = dictionary?["app_name"] as? String,
            let channelName = dictionary?["channel_name"] as? String,
            let channelUserID = dictionary?["channel_user_id"] as? String else {
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
