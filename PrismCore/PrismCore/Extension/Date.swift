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
        
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: string)
    }
}
