//
//  Mapable.swift
//  PrismCoreSDK
//
//  Created by fanni suyuti on 5/19/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

public protocol Mappable {
    init?(dictionary: [String: Any]?)
    func dictionaryValue() -> [String: Any]
}

public protocol MessageContentMappable : Mappable {
    
}
