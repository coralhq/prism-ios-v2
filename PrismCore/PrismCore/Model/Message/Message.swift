//
//  Message.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation


public typealias MessageChannelInfo = MessageUser
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
}

public enum MessageType {
    case Assignment
    case AutoResponder
    case Attachment
    case Cart
    case CloseChat
    case Invoice
    case OfflineMessage
    case PlainText
    case Product
    case StatusUpdate
    case Sticker
    case Typing
    
    public init?(rawValue: String) {
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
        default: return nil
        }
    }
}

open class Message: Mappable {
    var id: String
    var conversationID: String
    var merchantID: String
    var channel: String
    var channelInfo: MessageChannelInfo
    var visitor: MessageVisitorInfo
    var sender: MessageSender
    var type: MessageType
    var content: MessageContentMappable
    var version: Int
    var brokerMetaData: BrokerMetaData
    public let dictionaryValue: [String: Any]
    
    public required init?(dictionary: [String : Any]?) {
        guard let dictionary = dictionary,
            let id = dictionary["id"] as? String,
            let conversationID = dictionary["conversation_id"] as? String,
            let merchantID = dictionary["merchant_id"] as? String,
            let channel = dictionary["channel"] as? String,
            let channelInfo = MessageChannelInfo(dictionary: dictionary["channel_info"] as? [String: Any]),
            let visitor = MessageVisitorInfo(dictionary: dictionary["visitor"] as? [String: Any]),
            let sender = MessageSender(dictionary: dictionary["sender"] as? [String: Any]),
            let typeString = dictionary["type"] as? String,
            let type = MessageType(rawValue: typeString),
            let version = dictionary["version"] as? Int,
            let brokerMetaData = BrokerMetaData(dictionary: dictionary["_broker_metadata"] as? [String: Any]) else {
                return nil
        }
        
        if case .Assignment = type, let content = ContentAssignment(dictionary: dictionary["content"] as? [String: Any]) {
            self.content = content
        } else if case .AutoResponder = type, let content = ContentAutoResponder(dictionary: dictionary["content"] as? [String: Any]) {
            self.content = content
        } else if case .Attachment = type, let content = ContentAttachment(dictionary: dictionary["content"] as? [String: Any]) {
            self.content = content
        } else if case .Cart = type, let content = ContentCart(dictionary: dictionary["content"] as? [String: Any]) {
            self.content = content
        } else if case .CloseChat = type, let content = ContentCloseChat(dictionary: dictionary["content"] as? [String: Any]) {
            self.content = content
        } else if case .Invoice = type, let content = ContentInvoice(dictionary: dictionary["content"] as? [String: Any]) {
            self.content = content
        } else if case .OfflineMessage = type, let content = ContentOfflineMessage(dictionary: dictionary["content"] as? [String: Any]) {
            self.content = content
        } else if case .PlainText = type, let content = ContentPlainText(dictionary: dictionary["content"] as? [String: Any]) {
            self.content = content
        } else if case .Product = type, let content = ContentProduct(dictionary: dictionary["content"] as? [String: Any]) {
            self.content = content
        } else if case .StatusUpdate = type, let content = ContentStatusUpdate(dictionary: dictionary["content"] as? [String: Any]) {
            self.content = content
        } else if case .Sticker = type, let content = ContentSticker(dictionary: dictionary["content"] as? [String: Any]) {
            self.content = content
        } else if case .Typing = type, let content = ContentTyping(dictionary: dictionary["content"] as? [String: Any]) {
            self.content = content
        } else {
            return nil
        }
        
        self.type = type
        self.id = id
        self.merchantID = merchantID
        self.channelInfo = channelInfo
        self.conversationID = conversationID
        self.channel = channel
        self.visitor = visitor
        self.sender = sender
        self.brokerMetaData = brokerMetaData
        self.version = version
        self.dictionaryValue = dictionary
    }
    
    convenience private init?(
        id: String,
        conversationID: String,
        merchantID: String,
        channel: String,
        channelInfo: MessageChannelInfo,
        visitor: MessageVisitorInfo,
        sender: MessageSender,
        type: MessageType,
        content: [String: Any],
        brokerMetaData: BrokerMetaData) {
        
        self.init(dictionary: [
            "id": id,
            "conversation_id": conversationID,
            "merchant_id": merchantID,
            "channel": channel,
            "channel_info": channelInfo,
            "visitor": visitor,
            "sender": sender,
            "type": type,
            "content": content,
            "version": 2,
            "_broker_metadata": brokerMetaData
        ])
    }
    
    convenience public init?(id: String,
                            conversationID: String,
                            merchantID: String,
                            channel: String,
                            channelInfo: MessageChannelInfo,
                            visitor: MessageVisitorInfo,
                            sender: MessageSender,
                            type: MessageType,
                            content: ContentPlainText,
                            brokerMetaData: BrokerMetaData) {
        
        self.init(
            id: id,
            conversationID: conversationID,
            merchantID: merchantID,
            channel: channel,
            channelInfo: channelInfo,
            visitor: visitor,
            sender: sender,
            type: type,
            content: content.dictionaryValue,
            brokerMetaData: brokerMetaData
        )
    }
    
    convenience public init?(id: String,
                            conversationID: String,
                            merchantID: String,
                            channel: String,
                            channelInfo: MessageChannelInfo,
                            visitor: MessageVisitorInfo,
                            sender: MessageSender,
                            type: MessageType,
                            content: ContentAttachment,
                            brokerMetaData: BrokerMetaData) {
        
        self.init(
            id: id,
            conversationID: conversationID,
            merchantID: merchantID,
            channel: channel,
            channelInfo: channelInfo,
            visitor: visitor,
            sender: sender,
            type: type,
            content: content.dictionaryValue,
            brokerMetaData: brokerMetaData
        )
    }
    
    convenience public init?(id: String,
                            conversationID: String,
                            merchantID: String,
                            channel: String,
                            channelInfo: MessageChannelInfo,
                            visitor: MessageVisitorInfo,
                            sender: MessageSender,
                            type: MessageType,
                            content: ContentSticker,
                            brokerMetaData: BrokerMetaData) {
        
        self.init(
            id: id,
            conversationID: conversationID,
            merchantID: merchantID,
            channel: channel,
            channelInfo: channelInfo,
            visitor: visitor,
            sender: sender,
            type: type,
            content: content.dictionaryValue,
            brokerMetaData: brokerMetaData
        )
    }
    
    convenience public init?(id: String,
                            conversationID: String,
                            merchantID: String,
                            channel: String,
                            channelInfo: MessageChannelInfo,
                            visitor: MessageVisitorInfo,
                            sender: MessageSender,
                            type: MessageType,
                            content: ContentTyping,
                            brokerMetaData: BrokerMetaData) {
        
        self.init(
            id: id,
            conversationID: conversationID,
            merchantID: merchantID,
            channel: channel,
            channelInfo: channelInfo,
            visitor: visitor,
            sender: sender,
            type: type,
            content: content.dictionaryValue,
            brokerMetaData: brokerMetaData
        )
    }
}
