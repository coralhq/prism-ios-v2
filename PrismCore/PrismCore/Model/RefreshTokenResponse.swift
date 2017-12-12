//
//  RefreshTokenResponse.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/31/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

open class RefreshTokenResponse: NSObject, Mappable {
    
    let status: String?
    let message: String?
    public let oAuth: OAuth
    
    required public init?(dictionary: [String: Any]?) {
        guard let data = dictionary?["data"] as? [String: Any],
            let oAuth = OAuth(dictionary: data["oauth"] as? [String: Any]) else {
                return nil
        }
        
        self.status = dictionary?["status"] as? String
        self.message = dictionary?["message"] as? String
        self.oAuth = oAuth
    }
    
    public func dictionaryValue() -> [String : Any] {
        var data: [String: Any] = ["oauth": oAuth.dictionaryValue()]
        if let status = self.status {
            data["status"] = status
        }
        if let message = self.message {
            data["message"] = message
        }
        return ["data": data]
    }
}
