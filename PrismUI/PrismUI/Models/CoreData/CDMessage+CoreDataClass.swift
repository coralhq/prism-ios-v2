//
//  CDMessage+CoreDataClass.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/23/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import PrismCore
import CoreData

extension NSManagedObject {
    convenience init(with context: NSManagedObjectContext) {
        let entityDesc = NSEntityDescription.entity(forEntityName: String(describing: type(of: self)), in: context)!
        self.init(entity: entityDesc, insertInto: context)
    }
}

public class CDMessage: NSManagedObject {
    
    func setMessage(message: Message) {
        id = message.id
        conversationID = message.conversationID
        merchantID = message.merchantID
        channel = message.channel
        type = message.type.rawValue
        version = Int16(message.version)
        
        if let content = self.content as? CDContentEditable {
            content.editWithContent(content: message.content)
        } else {
            self.content = coreDataContentWith(content: message.content)
        }

        guard let context = managedObjectContext else { return }
        visitor = CDUser(context: context, user: message.visitor)
        sender = CDSender(context: context, sender: message.sender)
        brokerMetaData = CDBrokerMetaData(context: context, brokerMetaData: message.brokerMetaData)
        
        channelInfo = CDUser(context: context, user: message.channelInfo)
        
        sectionDate = brokerMetaData?.timestamp?.removedTime()
    }
    
    func coreDataContentWith(content: MessageContentMappable) -> NSObject? {
        if let content = content as? ContentSticker {
            return CDContentSticker(contentSticker: content)
        } else if let content = content as? ContentProduct {
            return CDContentProduct(contentProduct: content)
        } else if let content = content as? ContentOfflineMessage {
            return CDContentOfflineMessage(offlineMessage: content)
        } else if let content = content as? ContentCart {
            return CDContentCart(cart: content)
        } else if let content = content as? ContentPlainText {
            return CDContentPlainText(plainText: content)
        } else if let content = content as? ContentInvoice {
            return CDContentInvoice(invoice: content)
        } else if let content = content as? ContentAttachment {
            return CDContentAttachment(contentAttachment: content)
        } else {
            return nil
        }
    }
}

extension Date {
    func removedTime() -> Date? {
        let comp = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return Calendar.current.date(from: comp)
    }
}
