//
//  GetStickers.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/22/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

class GetStickersEndPoint: EndPoint {
    
    var token: String?
    var method = HTTPMethod.GET
    var url = URL.getStickers
    var httpBody: [String : Any] {
        get {
            return [:]
        }
    }
    var contentType: String? {
        get {
            return "application/json"
        }
    }
    
    init(token: String) {
        self.token = token
    }
}
