//
//  ChatContentType.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 7/5/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import PrismCore

enum ChatContentType: String {
    case Text = "text_cell"
    case Sticker = "sticker_cell"
    case Cart = "cart_cell"
    case Invoice = "invoice_cell"
    case Product = "product_cell"
    case Image = "image_cell"
    
    static func typeFrom(typeString: String) -> ChatContentType {
        let type = MessageType(rawValue: typeString)
        switch type {
        case .PlainText:
            return ChatContentType.Text
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
        default:
            return ChatContentType.Text
        }
    }
}
