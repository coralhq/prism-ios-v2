//
//  GetSettingsEndPoint.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/22/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

class GetSettingsEndPoint: EndPoint {
    var url = URL.getSettings
    var method = HTTPMethod.GET
    var token: String?
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
}
