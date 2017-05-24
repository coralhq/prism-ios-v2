//
//  EndPoint.swift
//  PrismCoreSDK
//
//  Created by fanni suyuti on 5/19/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

protocol EndPoint {
    
    var httpBody: [String: Any] { get }
    var url: URL { get }
    var method: HTTPMethod { get set }
    var token: String? { get set }
    var contentType: String? { get }
}
