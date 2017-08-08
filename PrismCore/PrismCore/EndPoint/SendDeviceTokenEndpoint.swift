//
//  SendDeviceTokenEndpoint.swift
//  PrismCore
//
//  Created by fanni suyuti on 8/8/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

class SendDeviceTokenEndpoint: EndPoint {
    
    let visitorID: String
    let deviceToken: String
    
    var url: URL {
        get {
            return URL.sendDeviceToken(visitorID: visitorID)
        }
    }
    
    var method = HTTPMethod.POST
    var token: String?
    var httpBody: [String : Any] {
        get {
            return [
                "id": UIDevice.current.identifierForVendor?.description ?? String.randomUserID,
                "token": deviceToken,
                "device_type": "iOS"
            ]
        }
    }
    
    var contentType: String? {
        get {
            return "application/json"
        }
    }
    
    init(visitorID: String, deviceToken: String, authToken: String) {
        self.visitorID = visitorID
        self.token = authToken
        self.deviceToken = deviceToken
    }
}
