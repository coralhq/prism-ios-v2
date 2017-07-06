//
//  ChatManager.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 7/4/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import PrismCore
import CoreData

class ChatManager {
    var credential: PrismCredential
    var accessToken: String { return credential.accessToken }
    let coredata = CoreDataManager()
    
    init(credential: PrismCredential) {
        self.credential = credential
        
        NotificationCenter.default.addObserver(self, selector: #selector(chatReceived(sender:)), name: ReceiveChatNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chatDisconnect(sender:)), name: DisconnectChatNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chatError(sender:)), name: ErrorChatNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func connect(completionHandler: @escaping ((Bool, Error?) -> ())) {
        PrismCore.shared.connectToBroker(username: credential.username, password: credential.password) { (success, error) in
            completionHandler(success, error)
        }
    }
    
    func subscribe(completionHandler: @escaping ((Bool, Error?) -> ())) {
        PrismCore.shared.subscribeToTopic(credential.topic) { (success, error) in
            completionHandler(success, error)
        }
    }
    
    func sendMessage(text: String) {
        guard let content = ContentPlainText(text: text),
            let message = message(with: content, type: .PlainText) else { return }
        sendMessage(message: message)
    }
    
    func sendMessage(image: UIImage) {
        
    }
    
    func sendMessage(sticker: StickerViewModel) {
        guard let content = ContentSticker(name: sticker.name,
                                           imageURL: sticker.imageURL.absoluteString,
                                           id: sticker.id,
                                           packID: sticker.packID),
            let message = message(with: content, type: .Sticker) else { return }
        sendMessage(message: message)
    }
    
    private func sendMessage(message: Message) {
        //save to core data
        coredata?.saveMessage(message: message, status: .pending)
        
        //publish to mqtt
        PrismCore.shared.publishMessage(topic: credential.topic, message: message) { (message, error) in }
    }
    
    private func message(with content: MessageContentMappable, type: MessageType) -> Message? {
        return Message(id: NSUUID().uuidString.lowercased(),
                       conversationID: credential.conversationID,
                       merchantID: credential.merchantID,
                       channel: "IOS_SDK",
                       visitor: credential.visitorInfo,
                       sender: credential.sender,
                       type: type,
                       content: content,
                       brokerMetaData: BrokerMetaData())
    }
    
    @objc func chatReceived(sender: Notification) {
        guard let message = sender.object as? Message else { return }
        coredata?.saveMessage(message: message, status: .sent)
    }
    
    @objc func chatDisconnect(sender: Notification) {
        
    }
    
    @objc func chatError(sender: Notification) {
        
    }
}
