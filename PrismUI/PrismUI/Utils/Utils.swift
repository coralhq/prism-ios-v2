//
//  Utils.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/9/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation

class Utils {
    static func archive(object: Any, key: String) {
        let data = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(data, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func unarchive(key: String) -> Any? {
        guard let data = UserDefaults.standard.value(forKey: key) as? Data else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: data)
    }
}
