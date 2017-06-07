//
//  Utils.swift
//  PrismCore
//
//  Created by Nanang Rafsanjani on 6/7/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

class Utils: NSObject {
    static func jsonObject(from filename: String) -> Any? {
        let bundle = Bundle(for: Utils.classForCoder())
        guard let path = bundle.path(forResource: filename, ofType: "json") else { return nil }
        
        do {
            guard let data = try String(contentsOfFile: path).data(using: .utf8) else { return nil }
            let object = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.init(rawValue: 0))
            return object
        } catch {
            return nil
        }
    }
}
