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
    
    var messageTime: Date
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
            let messageTime = message.brokerMetaData?.timestamp else { return nil }
        
        self.contentType = ChatContentType.typeFrom(typeString: contentTypeString)
        self.cellType = senderID == visitor.id ? .Out : .In
        self.messageID = messageID
        self.senderID = senderID
        
        self.messageTime = messageTime
        
        if cellType == .Out {
            self.messageStatus = MessageStatus(rawValue: message.status)
        }
        
        if cellType == .Out {
            if Settings.shared.persona.enabled,
                let name = Settings.shared.persona.name {
                self.senderName = name
            } else {
                self.senderName = "Me".localized()
            }
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
        } else if let content = message.content as? CDContentOfflineMessage {
            contentViewModel = ContentOfflineViewModel(contentOfflineMessage: content)
        } else if let content = message.content as? CDContentCloseChat {
            contentViewModel = ContentCloseChatViewModel(contentText: content)
        }
    }
}

class ChatSectionViewModel {
    var indexTitle: String?
    var objects: [ChatViewModel]?
    
    init(info: NSFetchedResultsSectionInfo) {
        guard let messages = info.objects as? [CDMessage] else { return }
        
        objects = []
        for message in messages {
            guard let credential = Vendor.shared.credential,
                let vm = ChatViewModel(message: message, visitor: credential.sender) else { return }
            objects?.append(vm)
        }
        
        guard let date = messages.first?.sectionDate else { return }
        if Vendor.shared.calendar.isDate(date, equalTo: Date(), toGranularity: .year) {
            indexTitle = date.day()
        } else {
            indexTitle = date.dayWithYear()
        }
    }
}
