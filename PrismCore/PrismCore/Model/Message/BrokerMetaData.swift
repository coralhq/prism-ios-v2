//
//  BrokerMetaData.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

open class BrokerMetaData : NSObject, Mappable {
    
    public let timestamp: Date

    required public init?(dictionary: [String : Any]?) {
        guard let timestampString = dictionary?["timestamp"] as? String,
            let timestamp = timestampString.ISO8601Date else {
            return nil
        }
        
        self.timestamp = timestamp
    }
    
    public override init() {
        self.timestamp = Date().UTCTime
    }
    
    public func dictionaryValue() -> [String : Any] {
        return ["timestamp": timestamp.ISO8601String]
    }
}
