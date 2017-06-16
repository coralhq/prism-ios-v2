//
//  Visitor.swift
//  PrismCoreSDK
//
//  Created by fanni suyuti on 5/19/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

struct VisitorKeys {
    static let id = "id"
    static let name = "name"
    static let merchantID = "merchant_id"
    static let appName = "app_name"
    static let channelName = "channel_name"
    static let channelUserID = "channel_user_id"
}

//TODO: some properties might unused, re-check later
public class Visitor : Mappable, NSCoding {
    public var id: String
    public var name: String
    public var merchantID: String
    public var appName: String
    public var channelName: String
    public var channelUserID: String
    
    required public init?(dictionary: [String: Any]?) {
        guard let id = dictionary?[VisitorKeys.id] as? String,
            let name = dictionary?[VisitorKeys.name] as? String,
            let merchantID = dictionary?[VisitorKeys.merchantID] as? String,
            let appName = dictionary?[VisitorKeys.appName] as? String,
            let channelName = dictionary?[VisitorKeys.channelName] as? String,
            let channelUserID = dictionary?[VisitorKeys.channelUserID] as? String else {
                return nil
        }
        
        self.id = id
        self.name = name
        self.merchantID = merchantID
        self.appName = appName
        self.channelName = channelName
        self.channelUserID = channelUserID
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: VisitorKeys.id)
        aCoder.encode(name, forKey: VisitorKeys.name)
        aCoder.encode(merchantID, forKey: VisitorKeys.merchantID)
        aCoder.encode(appName, forKey: VisitorKeys.appName)
        aCoder.encode(channelName, forKey: VisitorKeys.channelName)
        aCoder.encode(channelUserID, forKey: VisitorKeys.channelUserID)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(coder: aDecoder)
        guard let id = aDecoder.decodeObject(forKey: VisitorKeys.id) as? String,
            let name = aDecoder.decodeObject(forKey: VisitorKeys.name) as? String,
            let merchantID = aDecoder.decodeObject(forKey: VisitorKeys.merchantID) as? String,
            let appName = aDecoder.decodeObject(forKey: VisitorKeys.appName) as? String,
            let channelName = aDecoder.decodeObject(forKey: VisitorKeys.channelName) as? String,
            let channelUserID = aDecoder.decodeObject(forKey: VisitorKeys.channelUserID) as? String else { return }
        
        self.id = id
        self.merchantID = merchantID
        self.name = name
        self.merchantID = merchantID
        self.appName = appName
        self.channelName = channelName
        self.channelUserID = channelUserID
    }
}
