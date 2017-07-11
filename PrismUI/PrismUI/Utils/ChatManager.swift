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
    var accessToken: String { return PrismCredential.shared.accessToken }
    let coredata = CoreDataManager()
    
    init() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(chatReceived(sender:)), name: ReceiveChatNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chatDisconnect(sender:)), name: DisconnectChatNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chatError(sender:)), name: ErrorChatNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func connect(completionHandler: @escaping ((Bool, Error?) -> ())) {
        PrismCore.shared.connectToBroker(username: PrismCredential.shared.username, password: PrismCredential.shared.password) { (success, error) in
            completionHandler(success, error)
        }
    }
    
    func subscribe(completionHandler: @escaping ((Bool, Error?) -> ())) {
        PrismCore.shared.subscribeToTopic(PrismCredential.shared.topic) { (success, error) in
            completionHandler(success, error)
        }
    }
    
    func sendMessage(text: String) {
        guard let content = ContentPlainText(text: text),
            let message = Message(id: NSUUID().uuidString.lowercased(),
                                  conversationID: PrismCredential.shared.conversationID,
                                  merchantID: PrismCredential.shared.merchantID,
                                  channel: "IOS_SDK",
                                  visitor: PrismCredential.shared.visitorInfo,
                                  sender: PrismCredential.shared.sender,
                                  type: .PlainText,
                                  content: content,
                                  brokerMetaData: BrokerMetaData()) else { return }
        
        coredata?.saveMessage(message: message, status: .pending)
        
        let trackerData = [
            sendMessageTrackerType.conversationID.rawValue : PrismCredential.shared.conversationID,
            sendMessageTrackerType.messageType.rawValue : message.type.rawValue,
            sendMessageTrackerType.sender.rawValue : message.sender.id
        ]
        
        PrismAnalytics.shared.sendTracker(withEvent: .sendMessage, data: trackerData)
        
        PrismCore.shared.publishMessage(token: PrismCredential.shared.accessToken, topic: PrismCredential.shared.topic, messages: [message]) { (response, error) in
            
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
