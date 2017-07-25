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
    
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
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
        
        if let version = dictionary["version"] as? Int {
            self.version = Int16(version)
        } else {
            self.version = 2
        }
        
        brokerMetaData = CDBrokerMetaData(with: context, dictionary: dictionary["_broker_metadata"] as! [String: Any])
        content = coreDataContentWith(dictionary: dictionary["content"] as! [String: Any], type: type)
        sectionDate = Date().removedTime()
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
                "version": Int(version),
                "_broker_metadata": brokerMetaData]
    }
    
    func coreDataContentWith(dictionary: [String: Any], type: String?) -> NSObject? {
        guard let type = type else {
            return nil
        }
        
        let messageType = MessageType(rawValue: type)
        switch messageType {
        case .Sticker:
            return CDContentSticker(dictionary: dictionary)
        case .Product:
            return CDContentProduct(dictionary: dictionary)
        case .OfflineMessage:
            return CDContentOfflineMessage(dictionary: dictionary)
        case .Cart:
            return CDContentCart(dictionary: dictionary)
        case .PlainText:
            return CDContentPlainText(dictionary: dictionary)
        case .Invoice:
            return CDContentInvoice(dictionary: dictionary)
        case .Attachment:
            return CDContentAttachment(dictionary: dictionary)
        default:
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
