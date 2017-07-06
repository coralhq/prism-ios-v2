//
//  ChatViewModel.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/16/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import CoreData
import PrismCore

class ChatViewModel {
    private let message: CDMessage
    
    let cellType: ChatCellType
    let messageID: String
    let contentType: ChatContentType
    let senderID: String
    
    var messageTime: String
    var senderName: String
    var statusIcon: UIImage? {
        if cellType == .Out {
            if messageStatus == .sent {
                return UIImage(named: "icStatusRead", in: Bundle.prism, compatibleWith: nil)
            } else {
                return UIImage(named: "icStatusSending", in: Bundle.prism, compatibleWith: nil)
            }
        } else {
            return nil
        }
    }
    
    var messageStatus: MessageStatus?
    var contentViewModel: ContentViewModel?
    
    init?(message: CDMessage, visitor: MessageSender) {
        self.message = message
        
        guard let contentTypeString = message.type,
            let senderID = message.sender?.id,
            let senderName = message.sender?.name,
            let messageID = message.id,
            let timestampe = message.brokerMetaData?.timestamp else { return nil }
        
        self.contentType = ChatContentType.typeFrom(typeString: contentTypeString)
        self.cellType = senderID == visitor.id ? .Out : .In
        self.messageID = messageID
        self.senderID = senderID
        
        Vendor.shared.dateFormatter.dateFormat = "hh:mm a"
        self.messageTime = Vendor.shared.dateFormatter.string(from: timestampe)
        
        if cellType == .Out {
            self.messageStatus = MessageStatus(rawValue: message.status)
        }
        
        if cellType == .Out {
            self.senderName = "Me".localized()
        } else {
            self.senderName = senderName
        }
        
        if let content = message.content as? CDContentPlainText {
            contentViewModel = ContentTextViewModel(contentText: content)
        } else if let content = message.content as? CDContentSticker {
            contentViewModel = ContentStickerViewModel(contentSticker: content)
        } else if let content = message.content as? CDContentCart {
            contentViewModel = ContentCartViewModel(contentCart: content)
        } else if let content = message.content as? CDContentProduct {
            contentViewModel = ContentProductViewModel(contentProduct: content)
        } else if let content = message.content as? CDContentInvoice {
            contentViewModel = ContentInvoiceViewModel(contentInvoice: content)
        } else if let content = message.content as? CDContentAttachment {
            contentViewModel = ContentImageViewModel(contentImage: content)
        }
    }
}

class ChatSectionViewModel {
    var indexTitle: String?
    var objects: [ChatViewModel]?
    
    init(info: NSFetchedResultsSectionInfo, credential: PrismCredential) {
        guard let messages = info.objects as? [CDMessage] else { return }
        
        objects = []
        for message in messages {
            guard let vm = ChatViewModel(message: message, visitor: credential.sender) else { return }
            objects?.append(vm)
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
