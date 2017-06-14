//
//  UIFont.swift
//  PrismUI
//
//  Created by fanni suyuti on 6/12/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation

extension UIFont {
    class func welcomeMessageFont() -> UIFont {
        return UIFont.systemFont(ofSize: 14.0, weight: UIFontWeightRegular)
    }
    
    class func navigationTitleFont() -> UIFont {
        return UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightBold)
    }
    
    class func navigationSubTitleFont() -> UIFont {
        return UIFont.systemFont(ofSize: 10.0, weight: UIFontWeightRegular)
    }
}
