//
//  Date.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/23/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

extension Date {
    static func getDateFromISO8601(string: String?) -> Date? {
        guard let string = string else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter.date(from: string)
    }
}
