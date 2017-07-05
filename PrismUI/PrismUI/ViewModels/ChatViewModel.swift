//
//  ChatViewModel.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/16/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import PrismCore
import CoreData

enum ChatCellType: String {
    case In = "_in"
    case Out = "_out"
}

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

class ChatViewModel {
    let senderID: String
    let messageID: String
    let contentType: ChatContentType
    init(message: CDMessage) {
        contentType = ChatContentType.typeFrom(typeString: message.type!)
        senderID = message.sender!.id!
        messageID = message.id!
    }
}

class ChatSectionViewModel {
    var indexTitle: String?
    var objects: [ChatViewModel]?
    
    init(info: NSFetchedResultsSectionInfo) {
        guard let messages = info.objects as? [CDMessage] else { return }
        
        objects = []
        for message in messages {
            objects?.append(ChatViewModel(message: message))
        }
        
        guard let date = messages.first?.sectionDate else { return }
        if Vendor.shared.calendar.isDate(date, equalTo: Date(), toGranularity: .year) {
            Vendor.shared.dateFormatter.dateFormat = DateFormatVendor.dayFormat
        } else {
            Vendor.shared.dateFormatter.dateFormat = DateFormatVendor.dayWithYearFormat
        }
        indexTitle = Vendor.shared.dateFormatter.string(from: date)
    }
}
