//
//  Message.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

public typealias MessageVisitorInfo = MessageUser

public enum TypingStatus : String {
    case StartTyping = "start_typing"
    case EndTyping = "end_typing"
    
    public init?(rawValue: String) {
        switch rawValue {
        case "start_typing":
            self = .StartTyping
        case "end_typing":
            self = .EndTyping
        default:
            return nil
        }
    }
    
    public var rawValue: String {
        switch self {
        case .StartTyping:
            return "start_typing"
        case .EndTyping:
            return "end_typing"
        }
    }
}

public enum MessageType: String {
    case Assignment = "assignment"
    case AutoResponder = "auto_responder"
    case Attachment = "attachment"
    case Cart = "cart"
    case CloseChat = "close_chat"
    case Invoice = "invoice"
    case OfflineMessage = "offline_message"
    case PlainText = "text"
    case Product = "product"
    case StatusUpdate = "message_status_update"
    case Sticker = "sticker"
    case Typing = "typing"
    case Unknown = "unknown"
    
    public init(rawValue: String) {
        switch rawValue {
        case "auto_responder": self = .AutoResponder
        case "assignment": self = .Assignment
        case "attachment": self = .Attachment
        case "cart": self = .Cart
        case "close_chat": self = .CloseChat
        case "invoice": self = .Invoice
        case "offline_message": self = .OfflineMessage
        case "text": self = .PlainText
        case "product": self = .Product
        case "message_status_update": self = .StatusUpdate
        case "sticker": self = .Sticker
        case "typing": self = .Typing
        default: self = .Unknown
        }
    }
}

open class Message: NSObject, Mappable {
    public var id: String
    public var conversationID: String
    public var merchantID: String
    public var channel: String
    public var visitor: MessageVisitorInfo
    public var sender: MessageSender?
    public var type: MessageType
    public var content: MessageContentMappable
    public var version: Int
    public var brokerMetaData: BrokerMetaData
    
    public var channelInfo: MessageChannelInfo?
    
    public required init?(dictionary: [String : Any]?) {
        let dictionary: [String: Any] = dictionary ?? [:]
        guard
            let id = dictionary["id"] as? String,
            let conversationID = dictionary["conversation_id"] as? String,
            let merchantID = dictionary["merchant_id"] as? String,
            let channel = dictionary["channel"] as? String,
            let visitor = MessageVisitorInfo(dictionary: dictionary["visitor"] as? [String: Any]),
            let typeString = dictionary["type"] as? String,
            let version = dictionary["version"] as? Int,
            let brokerMetaData = BrokerMetaData(dictionary: dictionary["_broker_metadata"] as? [String: Any]) else {
                return nil
        }
        
        self.channelInfo = MessageChannelInfo(dictionary: dictionary["channel_info"] as? [String: Any])
        self.type = MessageType(rawValue: typeString)
        self.sender = MessageSender(dictionary: dictionary["sender"] as? [String: Any])
        
        self.id = id
        self.merchantID = merchantID
        self.conversationID = conversationID
        self.channel = channel
        self.visitor = visitor
        self.brokerMetaData = brokerMetaData
        self.version = version
        
        guard let contentDict = dictionary["content"] as? [String: Any],
            let content = Message.contentWith(dictionary: contentDict, type: type) else {
            return nil
        }
        self.content = content
        
    }
    
    public init(id: String,
                conversationID: String,
                merchantID: String,
                channel: String,
                visitor: MessageVisitorInfo,
                sender: MessageSender,
                type: MessageType,
                content: MessageContentMappable,
                brokerMetaData: BrokerMetaData,
                channelInfo: MessageChannelInfo? = nil) {
        self.id = id
        self.conversationID = conversationID
        self.merchantID = merchantID
        self.channel = channel
        self.visitor = visitor
        self.sender = sender
        self.type = type
        self.content = content
        self.brokerMetaData = brokerMetaData
        self.channelInfo = channelInfo
        self.version = 2
    }
    
    public func dictionaryValue() -> [String: Any] {
        return ["id": id,
                "conversation_id": conversationID,
                "merchant_id": merchantID,
                "channel": channel,
                "visitor": visitor.dictionaryValue(),
                "sender": sender?.dictionaryValue() ?? [:],
                "type": type.rawValue,
                "content": content.dictionaryValue(),
                "version": version,
                "_broker_metadata": brokerMetaData.dictionaryValue()]
    }
    
    static func contentWith(dictionary: [String: Any], type: MessageType) -> MessageContentMappable? {
        switch type {
        case .Assignment:
            return ContentAssignment(dictionary: dictionary)
        case .Attachment:
            return ContentAttachment(dictionary: dictionary)
        case .AutoResponder:
            return ContentAutoResponder(dictionary: dictionary)
        case .Cart:
            return ContentCart(dictionary: dictionary)
        case .CloseChat:
            return ContentCloseChat(dictionary: dictionary)
        case .Invoice:
            return ContentInvoice(dictionary: dictionary)
        case .OfflineMessage:
            return ContentOfflineMessage(dictionary: dictionary)
        case .PlainText:
            return ContentPlainText(dictionary: dictionary)
        case .Product:
            return ContentProduct(dictionary: dictionary)
        case .StatusUpdate:
            return ContentStatusUpdate(dictionary: dictionary)
        case .Sticker:
            return ContentSticker(dictionary: dictionary)
        case .Typing:
            return ContentTyping(dictionary: dictionary)
        case .Unknown:
            return nil
        }
    }
}
