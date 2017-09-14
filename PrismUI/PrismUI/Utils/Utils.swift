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
    
    static func formatted(selectedOptions: [String: Any]?, with options: [String: Any]?) -> String? {
        if let options = options,
            let selectedOptions = selectedOptions {
            
            let formattedOptions = selectedOptions.map({ (key, value) -> String in
                guard let option = options[key] as? [String: Any],
                    let type = option["type"] as? String else { return "-" }
                
                if type == "radio" {
                    
                    guard let radioID = value as? String else { return "-" }
                    let radios = option[type] as! [[String: Any]]
                    let selectedRadio = radios.filter({ (radio) -> Bool in
                        guard let selectedRadioID = radio["id"] as? String else { return false }
                        return selectedRadioID == radioID
                    })
                    guard let result = selectedRadio.first?["label"] as? String else { return "-" }
                    return result
                    
                } else if type == "checkbox" {
                    
                    guard let checkedboxIDs = value as? [String],
                        let checkboxes = option[type] as? [[String: Any]] else { return "-" }
                    let checkedBoxes = checkboxes.filter({ (checkbox) -> Bool in
                        guard let checkboxID = checkbox["id"] as? String else { return false }
                        return checkedboxIDs.contains(checkboxID)
                    })
                    let result = checkedBoxes.map( { $0["label"] as! String } )
                    return result.joined(separator: ", ")
                    
                } else if type == "select" {
                    
                    guard let selectID = value as? String else { return "-" }
                    let selectOptions = option[type] as! [[String: Any]]
                    let selectedOptions = selectOptions.filter({ (selectOption) -> Bool in
                        guard let selectedID = selectOption["id"] as? String else { return false }
                        return selectedID == selectID
                    })
                    guard let result = selectedOptions.first?["label"] as? String else { return "-" }
                    return result
                    
                } else if type == "text" {
                    
                    guard let text = value as? String else { return "-" }
                    return text
                    
                } else {
                    return "-"
                }
            })
            
            return formattedOptions
                .filter({ $0 != "-" })
                .map({ $0.replacingOccurrences(of: " ", with: "") })
                .joined(separator: ", ")
        } else {
            return nil
        }
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
