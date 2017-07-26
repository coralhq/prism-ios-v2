//
//  ChatContentView.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/19/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import PrismCore

struct ContentWidthInfo {
    var lastWidth: CGFloat = 0
    var widestWidth: CGFloat = 0
}

class ChatContentView: UIView {
    var widthInfo: ContentWidthInfo = ContentWidthInfo()
    
    var contentConstraint: CGSize {
        let sideCount: CGFloat = 2
        let maxContentWidth = UIScreen.main.bounds.width - chatContentPadding * sideCount - chatBublePadding * sideCount
        let constraint = CGSize(width: maxContentWidth, height: maxViewSize)
        return constraint
    }
    
    func updateView(with viewModel: ChatViewModel) {}
    
    static func contentFromNIB() -> ChatContentView? {
        return self.viewFromNib()
    }
    
    func calculateContentWidth(label: UILabel) {
        guard let text = label.text else {
            return
        }
        var widestWidth: CGFloat = 0
        var lastWidth: CGFloat = 0
        let linedStrings = text.linesArrayString(constraint: contentConstraint, font: label.font)
        for (index, value) in linedStrings.enumerated() {
            let width = value.width(font: label.font)
            
            if widestWidth < width {
                widestWidth = width
            }
            
            if index == linedStrings.count - 1 {
                lastWidth = width
            }
        }
        widthInfo = ContentWidthInfo(lastWidth: lastWidth, widestWidth: widestWidth)
    }
}

enum ChatContentType: String {
    case Text = "text_cell"
    case OfflineMessage = "offline_message"
    case Sticker = "sticker_cell"
    case Cart = "cart_cell"
    case Invoice = "invoice_cell"
    case Product = "product_cell"
    case Image = "image_cell"
    
    static func typeFrom(typeString: String) -> ChatContentType {
        let type = MessageType(rawValue: typeString)
        switch type {
        case .Sticker:
            return ChatContentType.Sticker
        case .Cart:
            return ChatContentType.Cart
        case .Invoice:
            return ChatContentType.Invoice
        case .Product:
            return ChatContentType.Product
        case .Attachment:
            return ChatContentType.Image
        case .OfflineMessage:
            return ChatContentType.OfflineMessage
        case .PlainText: fallthrough
        default:
            return ChatContentType.Text
        }
    }
}
