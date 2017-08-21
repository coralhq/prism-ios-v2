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
    public let expireIn: Int
    
    required public init?(dictionary: [String: Any]?) {
        guard let refreshToken = dictionary?["refresh_token"] as? String,
            let tokenType = dictionary?["token_type"] as? String,
            let accessToken = dictionary?["access_token"] as? String,
            let clientID = dictionary?["client_id"] as? String,
            let expireIn = dictionary?["expires_in"] as? Int
            else {
                return nil
        }
        
        self.refreshToken = refreshToken
        self.tokenType = tokenType
        self.accessToken = accessToken
        self.clientID = clientID
        self.expireIn = expireIn
    }
    
    public func dictionaryValue() -> [String : Any] {
        return ["refresh_token": refreshToken,
                "token_type": tokenType,
                "access_token": accessToken,
                "client_id": clientID,
                "expires_in": expireIn]
    }
}

