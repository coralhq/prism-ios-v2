//
//  Number.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/20/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    var degreesToRadians: CGFloat { return CGFloat(self) * .pi / 180 }
}
extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}

extension Double {
    func formattedCurrency(currencyCode: String?) -> String {
        let locale = Locale
            .availableIdentifiers
            .map({ Locale(identifier: $0) })
            .first{ $0.currencyCode == currencyCode }
        
        if let locale = locale {
            Vendor.shared.currencyFormatter.locale = locale
        }
        
        guard let formatted = Vendor.shared.currencyFormatter.string(from: NSNumber(floatLiteral: self)) else {
            return "Invalid currency number."
        }
        return formatted
    }
}
