//
//  BrokerMetaData.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

class BrokerMetaData : Mappable {
    
    let timestamp: Date
    
    required init?(json: [String : Any]?) {
        guard let timestamp = Date.getDateFromISO8601(string: json?["timestamp"] as? String) else {
            return nil
        }
        
        self.timestamp = timestamp
    }
}
