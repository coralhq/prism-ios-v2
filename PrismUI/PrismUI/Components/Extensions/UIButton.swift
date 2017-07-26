//
//  UIButton.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 7/26/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation

extension UIButton {
    func startLoading() {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        indicator.color = Settings.shared.theme.strokeColor
        indicator.startAnimating()
        indicator.tag = 212 //random number, act as indicator id
        
        let titleFrame = titleRect(forContentRect: bounds)
        var frame = titleFrame
        frame.size.width = titleFrame.height
        frame.origin = CGPoint(x: titleFrame.maxX + 8, y: titleFrame.minY)
        indicator.frame = frame
        
        addSubview(indicator)
    }
    
    func stopLoading() {
        for view in subviews {
            if view.tag == 212 {
                view.removeFromSuperview()
            }
        }
    }
}
