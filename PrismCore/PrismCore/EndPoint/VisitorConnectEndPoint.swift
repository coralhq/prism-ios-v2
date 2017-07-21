//
//  VisitorConnect.swift
//  PrismCoreSDK
//
//  Created by fanni suyuti on 5/18/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

class VisitorConnectEndPoint : EndPoint {
    
    let userID: String
    
    var method = HTTPMethod.POST
    var token: String?
    let visitorName: String
    var url = URL.prismConnect
    var httpBody: [String: Any] {
        get {
            return [
                "name": visitorName,
                "merchant_id": Config.shared.getMerchantID()!,
                "channel_name": PrismChannelName,
                "channel_user_id": userID,
                "app_name": "paw"
            ]
        }
    }
    var contentType: String? {
        get {
            return "application/json"
        }
    }

    init(visitorName: String, userID: String) {
        self.userID = userID
        self.visitorName = visitorName
    }
}




