//
//  BrokerMetaData.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

public class BrokerMetaData : Mappable {
    
    public let timestamp: Date
    
    public var dictionaryValue: [String: Any] {
        get {
            return [
                "timestamp": timestamp.ISO8601String
            ]
        }
    }
    
    required public init?(dictionary: [String : Any]?) {
        guard let timestampString = dictionary?["timestamp"] as? String,
            let timestamp = timestampString.ISO8601Date else {
            return nil
        }
        
        self.timestamp = timestamp
    }
    
    public init() {
        self.timestamp = Date()
    }
    
}
