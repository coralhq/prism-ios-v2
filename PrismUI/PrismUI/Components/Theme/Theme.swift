//
//  Theme.swift
//  PrismUI
//
//  Created by fanni suyuti on 6/12/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import UIKit

public enum ThemeType {
    case AzureWhite
    case JetBlack
    case PinkScarlet
    case CitrusLime
    case OceanBlue
    case CoralReef
    case BananaTokyo
    
    public init(settings: [String: Any]) {
        guard let widget = settings["widget"] as? [String: Any],
            let appearance = widget["appearance"] as? [String: Any],
            let theme = appearance["color_theme"] as? String else {
                self = .OceanBlue
                return
        }
        
        switch theme {
        case "PINK":
            self = .PinkScarlet
            
        case "BLACK":
            self = .JetBlack
            
        case "WHITE":
            self = .AzureWhite
            
        case "GREEN":
            self = .CitrusLime
            
        case "RED":
            self = .CoralReef
            
        case "YELLOW":
            self = .BananaTokyo
            
        case "BLUE": fallthrough
        default:
            self = .OceanBlue
        }
    }
    
}

open class Theme {
    open var headerColor: UIColor
    open var strokeColor: UIColor
    open var buttonColor: UIColor
    
    init() {
        headerColor = UIColor.white
        strokeColor = UIColor.steelBlue
        buttonColor = UIColor.steelBlue
    }
    
    func configure(option: ThemeType) {
        switch option {
        case .AzureWhite:
            headerColor = UIColor.white
            strokeColor = UIColor.steelBlue
            buttonColor = UIColor.steelBlue
            
        case .JetBlack:
            headerColor = UIColor.jetBlack
            buttonColor = UIColor.jetBlack
            strokeColor = UIColor.white
            
        case .PinkScarlet:
            headerColor = UIColor.fadedRed
            buttonColor = UIColor.fadedRed
            strokeColor = UIColor.white
            
        case .CitrusLime:
            headerColor = UIColor.coolGreen
            buttonColor = UIColor.coolGreen
            strokeColor = UIColor.white
            
        case .OceanBlue:
            headerColor = UIColor.darkSkyBlue
            buttonColor = UIColor.darkSkyBlue
            strokeColor = UIColor.white
            
        case .CoralReef:
            headerColor = UIColor.tomato
            buttonColor = UIColor.tomato
            strokeColor = UIColor.white
            
        case .BananaTokyo:
            headerColor = UIColor.yellowOrange
            buttonColor = UIColor.yellowOrange
            strokeColor = UIColor.white
        }
    }
}
