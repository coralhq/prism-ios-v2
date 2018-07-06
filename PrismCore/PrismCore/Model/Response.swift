//
//  Response.swift
//  PrismCore
//
//  Created by Nanang Rafsanjani on 06/07/18.
//  Copyright © 2018 PrismApp. All rights reserved.
//

import UIKit

open
class GeneralResponse: NSObject, Mappable {
    public let status: String
    public let data: [String: Any]?
    
    public required init?(dictionary: [String : Any]?) {
        guard let status = dictionary?["status"] as? String else {
            return nil
        }
        self.status = status
        self.data = dictionary?["data"] as? [String: Any]
    }
    
    public func dictionaryValue() -> [String : Any] {
        var result: [String: Any] = ["status": status]
        if let data = data { result["data"] = data }
        return result
    }
}
