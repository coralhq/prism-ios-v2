//
//  Theme.swift
//  PrismUI
//
//  Created by fanni suyuti on 6/12/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import UIKit

public enum ThemeOptions {
    case AzureWhite
    case JetBlack
    case PinkScarlet
    case CitrusLime
    case OceanBlue
    case CoralReef
    case BananaTokyo
    
    public init(settings: [String: Any]) {
        let rawValue = (settings["widget"] as! [String: Any])["style"] as! String        
        switch rawValue {
        case "PINK": self = .PinkScarlet
        case "BLACK": self = .JetBlack
        case "WHITE": self = .AzureWhite
        case "GREEN": self = .CitrusLime
        case "RED": self = .CoralReef
        case "YELLOW": self = .BananaTokyo
        case "BLUE": fallthrough
        default:
            self = .OceanBlue
        }
    }
}

open class Theme {
    open var navigationBarColor: UIColor
    open var navigationBarTitleColor: UIColor
    open var mainViewBackgroundColor: UIColor
    open var chatSentBubbleBackgroundColor: UIColor
    open var chatSentBubleBorderColor: UIColor
    open var chatReceivedBubbleBackgroundColor: UIColor
    open var chatReceivedBubleBorderColor: UIColor
    open var chatTextColor: UIColor
    open var chatSenderTextColor: UIColor
    
    init() {
        navigationBarColor = UIColor.white
        navigationBarTitleColor = UIColor.steelBlue
        mainViewBackgroundColor = UIColor.steelBlueMainViewFill
        chatSentBubbleBackgroundColor = UIColor.steelBlueFill
        chatSentBubleBorderColor = UIColor.steelBlueBorder
        chatReceivedBubbleBackgroundColor = UIColor.white
        chatReceivedBubleBorderColor = UIColor.steelBlueBorder
        chatTextColor = UIColor.jetBlack
        chatSenderTextColor = UIColor.jetBlack
    }
    
    func configure(option: ThemeOptions) {
        switch option {
        case .AzureWhite:
            navigationBarColor = UIColor.white
            navigationBarTitleColor = UIColor.steelBlue
            mainViewBackgroundColor = UIColor.steelBlueMainViewFill
            chatSentBubbleBackgroundColor = UIColor.steelBlueFill
            chatSentBubleBorderColor = UIColor.steelBlueBorder
            chatReceivedBubbleBackgroundColor = UIColor.white
            chatReceivedBubleBorderColor = UIColor.steelBlueBorder
            chatTextColor = UIColor.jetBlack
            chatSenderTextColor = UIColor.jetBlack
            
        case .JetBlack:
            navigationBarColor = UIColor.jetBlack
            navigationBarTitleColor = UIColor.white
            mainViewBackgroundColor = UIColor.jetBlackMainViewFill
            chatSentBubbleBackgroundColor = UIColor.jetBlackFill
            chatSentBubleBorderColor = UIColor.jetBlackBorder
            chatReceivedBubbleBackgroundColor = UIColor.white
            chatReceivedBubleBorderColor = UIColor.jetBlackBorder
            chatTextColor = UIColor.jetBlack
            chatSenderTextColor = UIColor.jetBlack
            
        case .PinkScarlet:
            navigationBarColor = UIColor.fadedRed
            navigationBarTitleColor = UIColor.white
            mainViewBackgroundColor = UIColor.fadedRedMainViewFill
            chatSentBubbleBackgroundColor = UIColor.fadedRedFill
            chatSentBubleBorderColor = UIColor.fadedRedBorder
            chatReceivedBubbleBackgroundColor = UIColor.white
            chatReceivedBubleBorderColor = UIColor.fadedRedBorder
            chatTextColor = UIColor.jetBlack
            chatSenderTextColor = UIColor.jetBlack
            
        case .CitrusLime:
            navigationBarColor = UIColor.coolGreen
            navigationBarTitleColor = UIColor.white
            mainViewBackgroundColor = UIColor.coolGreenMainViewFill
            chatSentBubbleBackgroundColor = UIColor.coolGreenFill
            chatSentBubleBorderColor = UIColor.coolGreenBorder
            chatReceivedBubbleBackgroundColor = UIColor.white
            chatReceivedBubleBorderColor = UIColor.coolGreenBorder
            chatTextColor = UIColor.jetBlack
            chatSenderTextColor = UIColor.jetBlack
            
        case .OceanBlue:
            navigationBarColor = UIColor.darkSkyBlue
            navigationBarTitleColor = UIColor.white
            mainViewBackgroundColor = UIColor.darkSkyBlueMainViewFill
            chatSentBubbleBackgroundColor = UIColor.darkSkyBlueFill
            chatSentBubleBorderColor = UIColor.darkSkyBlueBorder
            chatReceivedBubbleBackgroundColor = UIColor.white
            chatReceivedBubleBorderColor = UIColor.darkSkyBlueBorder
            chatTextColor = UIColor.jetBlack
            chatSenderTextColor = UIColor.jetBlack
            
        case .CoralReef:
            navigationBarColor = UIColor.tomato
            navigationBarTitleColor = UIColor.white
            mainViewBackgroundColor = UIColor.tomatoMainViewFill
            chatSentBubbleBackgroundColor = UIColor.tomatoFill
            chatSentBubleBorderColor = UIColor.tomatoBorder
            chatReceivedBubbleBackgroundColor = UIColor.white
            chatReceivedBubleBorderColor = UIColor.tomatoBorder
            chatTextColor = UIColor.jetBlack
            chatSenderTextColor = UIColor.jetBlack
            
        case .BananaTokyo:
            navigationBarColor = UIColor.yellowOrange
            navigationBarTitleColor = UIColor.white
            mainViewBackgroundColor = UIColor.yellowOrangeMainViewFill
            chatSentBubbleBackgroundColor = UIColor.yellowOrangeFill
            chatSentBubleBorderColor = UIColor.yellowOrangeBorder
            chatReceivedBubbleBackgroundColor = UIColor.white
            chatReceivedBubleBorderColor = UIColor.yellowOrangeBorder
            chatTextColor = UIColor.jetBlack
            chatSenderTextColor = UIColor.jetBlack
            
        }
    }
}
