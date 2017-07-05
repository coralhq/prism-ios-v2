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
    var messageTime: String
    var messageStatus: MessageStatus?
    var senderName: String {
        if cellType == .Out {
            return "Me".localized()
        } else {
            return message.sender!.name!
        }
    }
    
    var contentViewModel: ContentViewModel?
    
    init(message: CDMessage, visitor: MessageSender) {
        self.message = message
        
        contentType = ChatContentType.typeFrom(typeString: message.type!)
        cellType = (message.sender!.id! == visitor.id) ? .Out : .In
        messageID = message.id!
        
        Vendor.shared.dateFormatter.dateFormat = "hh:mm a"
        messageTime = Vendor.shared.dateFormatter.string(from: message.brokerMetaData!.timestamp!)
        
        if cellType == .Out {
            messageStatus = MessageStatus(rawValue: message.status)
        }
        
        if let content = message.content as? CDContentPlainText {
            contentViewModel = ContentTextViewModel(contentText: content)
        } else if let content = message.content as? CDContentSticker {
            contentViewModel = ContentStickerViewModel(contentSticker: content)
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
            objects?.append(ChatViewModel(message: message, visitor: credential.sender))
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
