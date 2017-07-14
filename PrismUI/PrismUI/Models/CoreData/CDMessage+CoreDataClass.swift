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

public class CDMessage: NSManagedObject, CDManagedMappable {
    
    required public init(with context: NSManagedObjectContext, dictionary: [String : Any]) {
        let entityDesc = NSEntityDescription.entity(forEntityName: String(describing: type(of: self)), in: context)!
        super.init(entity: entityDesc, insertInto: context)
        
        updateMessage(with: dictionary)
    }

    func updateMessage(with dictionary: [String: Any]) {
        guard let context = managedObjectContext else {
            return
        }
        id = dictionary["id"] as? String
        conversationID = dictionary["conversation_id"] as? String
        merchantID = dictionary["merchant_id"] as? String
        channel = dictionary["channel"] as? String
        visitor = CDUser(with: context, dictionary: dictionary["visitor"] as! [String : Any])
        sender = CDSender(with: context, dictionary: dictionary["sender"] as! [String : Any])
        type = dictionary["type"] as? String
        version = dictionary["version"] as! Int16
        brokerMetaData = CDBrokerMetaData(with: context, dictionary: dictionary["_broker_metadata"] as! [String: Any])
    }
    
    func dictionaryValue() -> [String : Any]? {
        guard let id = id,
            let conversationID = conversationID,
            let merchantID = merchantID,
            let channel = channel,
            let visitor = visitor?.dictionaryValue(),
            let sender = sender?.dictionaryValue(),
            let type = type,
            let content = (content as? CDMappable)?.dictionaryValue(),
            let brokerMetaData = brokerMetaData?.dictionaryValue() else {
                return nil
        }
        return ["id": id,
                "conversation_id": conversationID,
                "merchant_id": merchantID,
                "channel": channel,
                "visitor": visitor,
                "sender": sender,
                "type": type,
                "content": content,
                "version": version,
                "_broker_metadata": brokerMetaData]
    }
    
    func coreDataContentWith(content: MessageContentMappable) -> NSObject? {
        if let content = content as? ContentSticker {
            return CDContentSticker(dictionary: content.dictionaryValue())
        } else if let content = content as? ContentProduct {
            return CDContentProduct(dictionary: content.dictionaryValue())
        } else if let content = content as? ContentOfflineMessage {
            return CDContentOfflineMessage(dictionary: content.dictionaryValue())
        } else if let content = content as? ContentCart {
            return CDContentCart(dictionary: content.dictionaryValue())
        } else if let content = content as? ContentPlainText {
            return CDContentPlainText(dictionary: content.dictionaryValue())
        } else if let content = content as? ContentInvoice {
            return CDContentInvoice(dictionary: content.dictionaryValue())
        } else if let content = content as? ContentAttachment {
            return CDContentAttachment(dictionary: content.dictionaryValue())
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
