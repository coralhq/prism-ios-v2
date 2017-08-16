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
    
    static func unarchive<T>(key: String) -> T? {
        guard let data = UserDefaults.standard.value(forKey: key) as? Data else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? T
    }
}

extension Date {
    func ISO8601() -> String {
        Vendor.shared.dateFormatter.dateFormat = DateFormat.ISO8601Format
        return Vendor.shared.dateFormatter.string(from: self)
    }
    func day() -> String {
        Vendor.shared.dateFormatter.dateFormat = DateFormat.dayFormat
        return Vendor.shared.dateFormatter.string(from: self)
    }
    func dayWithYear() -> String {
        Vendor.shared.dateFormatter.dateFormat = DateFormat.dayWithYearFormat
        return Vendor.shared.dateFormatter.string(from: self)
    }
}

extension String {
    func ISO8601() -> Date? {
        Vendor.shared.dateFormatter.dateFormat = DateFormat.ISO8601Format
        return Vendor.shared.dateFormatter.date(from: self)
    }
    func day() -> Date? {
        Vendor.shared.dateFormatter.dateFormat = DateFormat.dayFormat
        return Vendor.shared.dateFormatter.date(from: self)
    }
    func dayWithYear() -> Date? {
        Vendor.shared.dateFormatter.dateFormat = DateFormat.dayWithYearFormat
        return Vendor.shared.dateFormatter.date(from: self)
    }
}

struct DateFormat {
    static let ISO8601Format = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
    static let dayFormat = "MMMM dd"
    static let dayWithYearFormat = "MMMM dd, yyyy"
}

class Vendor {
    static let shared = Vendor()
    
    var credential: PrismCredential? {
        didSet {
            if let credential = credential {
                Utils.archive(object: credential, key: "prism_credential")
            } else {
                Utils.removeArchive(key: "prism_credential")
            }
        }
    }
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
        
        credential = Utils.unarchive(key: "prism_credential")
    }
    
    func getLocalDateWith(date: Date, format: String) -> String {
        let df = dateFormatter
        df.timeZone = TimeZone.current
        df.dateFormat = format
        
        return df.string(from: date)
    }
}
