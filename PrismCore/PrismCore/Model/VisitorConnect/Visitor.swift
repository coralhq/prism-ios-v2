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
    
    public func dictionaryValue() -> [String : Any] {
        return ["id": id,
                "name": name,
                "merchant_id": merchantID,
                "app_name": appName,
                "channel_name": channelName,
                "channel_user_id": channelUserID]
    }
}
