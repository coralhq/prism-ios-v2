//
//  Settings.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/22/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

open class Settings: Mappable {
    let data: [String: Any]
    
    public required init?(json: [String: Any]?) {
        guard let data = json?["data"] as? [String: Any] else {
            return nil
        }
        
        self.data = data
    }
}
