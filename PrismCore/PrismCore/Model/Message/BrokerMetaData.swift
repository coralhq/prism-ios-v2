//
//  BrokerMetaData.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

public class BrokerMetaData : Mappable {
    
    let timestamp: Date
    
    required public init?(dictionary: [String : Any]?) {
        guard let timestamp = Date.getDateFromISO8601(string: dictionary?["timestamp"] as? String) else {
            return nil
        }
        
        self.timestamp = timestamp
    }
    
    convenience public init?(timestamp: String) {
        let data = ["timestamp": timestamp]
        
        self.init(dictionary: data)
    }
}
