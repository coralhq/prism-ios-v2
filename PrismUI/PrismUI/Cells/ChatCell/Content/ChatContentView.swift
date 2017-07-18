//
//  ChatContentView.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/19/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import PrismCore

class ChatContentView: UIView {
    func infoPosition() -> InfoViewPosition { return .Bottom }
    func updateView(with viewModel: ChatViewModel) {}
    
    static func contentFromNIB() -> ChatContentView? {
        return self.viewFromNib() as? ChatContentView
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
