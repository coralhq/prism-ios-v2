//
//  GetDepartmentEndPoint.swift
//  PrismCore
//
//  Created by Nanang Rafsanjani on 06/07/18.
//  Copyright © 2018 PrismApp. All rights reserved.
//

import UIKit

class GetDepartmentEndPoint: EndPoint {
    var url: URL {
        get {
            return URL.getDepartments
        }
    }
    
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
    
    init(withToken token: String) {
        self.token = token
    }
}
