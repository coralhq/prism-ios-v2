//
//  SmallButton.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/21/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

class SmallButton: UIButton {
    @IBInspectable var disabledColor: UIColor = UIColor.gray
    @IBInspectable var color: UIColor = UIColor.red

    override var isEnabled: Bool {
        didSet {
            tintColor = isEnabled ? color : disabledColor
        }
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var _bounds = self.bounds
        
        let maxwidth = CGFloat(44.0)
        var widthDelta = maxwidth - _bounds.width
        if widthDelta <= 0 {
            widthDelta = 0
        }
        
        var heightDelta = maxwidth - _bounds.height
        if heightDelta <= 0 {
            heightDelta = 0
        }
        
        _bounds = _bounds.insetBy(dx: -widthDelta/2.0, dy: -heightDelta/2.0)
        return _bounds.contains(point)
    }

}
