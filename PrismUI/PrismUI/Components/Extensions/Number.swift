//
//  Number.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/20/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation

extension Int {
    var degreesToRadians: CGFloat { return CGFloat(self) * .pi / 180 }
}
extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
