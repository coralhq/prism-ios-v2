//
//  OAuth.swift
//  PrismCoreSDK
//
//  Created by fanni suyuti on 5/19/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

//TODO: some properties might unused, re-check later
public class OAuth : Mappable {
    public let refreshToken: String
    public let tokenType: String
    public let accessToken: String
    public let clientID: String
    public let expireIn: UInt64
    
    required public init?(json: [String: Any]?) {
        guard let refreshToken = json?["refresh_token"] as? String,
            let tokenType = json?["token_type"] as? String,
            let accessToken = json?["access_token"] as? String,
            let clientID = json?["client_id"] as? String,
            let expireIn = json?["expires_in"] as? UInt64
            else {
                return nil
        }
        
        self.refreshToken = refreshToken
        self.tokenType = tokenType
        self.accessToken = accessToken
        self.clientID = clientID
        self.expireIn = expireIn
    }
}
