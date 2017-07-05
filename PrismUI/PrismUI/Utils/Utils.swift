//
//  Utils.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/9/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation

class Utils {
    
    static func removeArchive(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func archive(object: Any, key: String) {
        let data = NSKeyedArchiver.archivedData(withRootObject: object)
        UserDefaults.standard.set(data, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func unarchive(key: String) -> Any? {
        guard let data = UserDefaults.standard.value(forKey: key) as? Data else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: data)
    }
}

struct DateFormatVendor {
    static let ISO8601Format = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
    static let dayFormat = "MMMM dd"
    static let dayWithYearFormat = "MMMM dd, yyyy"
}

class Vendor {
    static let shared = Vendor()
    
    let dateFormatter: DateFormatter
    let currencyFormatter: NumberFormatter
    let calendar = Calendar.current
    
    init() {
        dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .decimal
        currencyFormatter.groupingSeparator = ","
        currencyFormatter.decimalSeparator = "."
    }
}
