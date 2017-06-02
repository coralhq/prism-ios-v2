//
//  RefreshTokenEndPoint.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/31/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

class RefreshTokenEndPoint: EndPoint {
    
    let clientID: String
    let refreshToken: String
    
    var token: String?
    var method = HTTPMethod.POST
    var url = URL.refreshToken

    var httpBody: [String : Any] {
        get {
            return [
                "client_id": clientID,
                "refresh_token": refreshToken
            ]
        }
    }
    
    var contentType: String? {
        get {
            return "application/json"
        }
    }
    
    required init(clientID: String, refreshToken: String) {
        self.clientID = clientID
        self.refreshToken = refreshToken
    }
}
