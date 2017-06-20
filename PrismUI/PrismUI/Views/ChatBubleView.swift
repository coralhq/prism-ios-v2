//
//  ChatBubleView.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/16/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

enum ChatBubleType: Int {
    case In
    case Out
}

class ChatBubleView: UIView {
    
    @IBInspectable var strokeColor: UIColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    @IBInspectable var fillColor: UIColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
    @IBInspectable var cornerRadius: CGFloat = 5
    @IBInspectable var bubleTypeAdapter: Int {
        get {
            return bubleType.rawValue
        }
        set (value) {
            bubleType = ChatBubleType(rawValue: value)!
        }
    }
    
    var bubleType: ChatBubleType = .In
    
    override func draw(_ rect: CGRect) {
        let corners: UIRectCorner
        
        strokeColor.setStroke()
        fillColor.setFill()
        
        switch bubleType {
        case .In:
            corners = [.bottomLeft, .bottomRight, .topRight]
            break
        default:
            corners = [.bottomLeft, .bottomRight, .topLeft]
            break
        }
        
        let path = UIBezierPath(roundedRect: rect.removedFuzzyness(),
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        path.lineWidth = 1
        path.fill()
        path.stroke()
    }
    
}

extension CGRect {
    func removedFuzzyness() -> CGRect {
        var newRect = self
        newRect.origin.x += 0.5
        newRect.origin.y += 0.5
        newRect.size.width -= 1
        newRect.size.height -= 1
        return newRect
    }
}
