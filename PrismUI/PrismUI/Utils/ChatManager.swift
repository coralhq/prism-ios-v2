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
import PrismAnalytics

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
            let message = Message(id: NSUUID().uuidString.lowercased(),
                                  conversationID: credential.conversationID,
                                  merchantID: credential.merchantID,
                                  channel: "IOS_SDK",
                                  visitor: credential.visitorInfo,
                                  sender: credential.sender,
                                  type: .PlainText,
                                  content: content,
                                  brokerMetaData: BrokerMetaData()) else { return }
        
        coredata?.saveMessage(message: message, status: .pending)
        
        let trackerData = [
            sendMessageTrackerType.conversationID.rawValue : credential.conversationID,
            sendMessageTrackerType.messageType.rawValue : message.type.rawValue,
            sendMessageTrackerType.sender.rawValue : message.sender.id
        ]
        
        PrismAnalytics.shared.sendTracker(withEvent: .sendMessage, data: trackerData)
        
        PrismCore.shared.publishMessage(topic: credential.topic, message: message) { (message, error) in
            
        }
    }
    
    func sendMessage(image: UIImage) {
        
    }
    
    func sendMessage(sticker: StickerViewModel) {
        
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
