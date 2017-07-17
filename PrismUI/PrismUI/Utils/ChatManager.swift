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
    let credential = Vendor.shared.credential!
    let coredata = CoreDataManager()
    let reachability = ReachabilityHelper()!
    
    init() {
        
        do {
            try reachability.startNotifier()
        } catch{
            print("could not start reachability notifier")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(sender:)), name: ReachabilityChangedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chatReceived(sender:)), name: ReceiveChatNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chatDisconnect(sender:)), name: DisconnectChatNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chatError(sender:)), name: ErrorChatNotification, object: nil)
    }
    
    deinit {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self)
    }
    
    func connect(completionHandler: @escaping ((Bool, Error?) -> ())) {
        PrismCore.shared.connectToBroker(username: credential.username, password: credential.password) { (success, error) in
            PrismCore.shared.subscribeToTopic(self.credential.topic) { (success, error) in
                self.sendPendingMessages()
                completionHandler(success, error)
            }
        }
    }
    
    func sendMessage(text: String) {
        guard let content = ContentPlainText(text: text) else { return }
        let message = buildMessage(with: content, type: .PlainText)
        sendMessage(message: message)
    }
    
    func sendMessage(image: UIImage, imageName: String) {
        let content = ContentAttachment(name: imageName, mimeType: "image")
        let message = buildMessage(with: content, type: .Attachment)
        
        let temporaryKey = UUID().uuidString
        CacheVendor.shared.cacheImages.setObject(image, forKey: temporaryKey as NSString)
        
        guard let cd = coredata,
            let cdmessage = coredata?.buildMessage(message: message, status: .pending),
            let cdcontent = cdmessage.content as? CDContentAttachment else {
                return
        }
        cdcontent.url = temporaryKey
        cdcontent.uploadState = .start
        cdmessage.content = cdcontent
        cd.save()
        
        PrismCore.shared.getAttachmentURL(filename: imageName, conversationID: credential.conversationID, token: credential.accessToken) { (response, error) in
            guard let imageData = UIImagePNGRepresentation(image),
                let url = response?.uploadURL else {
                    return
            }
            
            var comp = URLComponents(url: url, resolvingAgainstBaseURL: false)
            comp?.query = nil
            comp?.fragment = nil
            
            guard let stringURL = comp?.url?.absoluteString else {
                return
            }
            CacheVendor.shared.cacheImages.removeObject(forKey: temporaryKey as NSString)
            CacheVendor.shared.cacheImages.setObject(image, forKey: stringURL as NSString)
            
            content.url = stringURL
            
            cdcontent.url = stringURL
            cdcontent.uploadState = .uploading
            cdmessage.content = cdcontent
            cd.save()
            
            PrismCore.shared.uploadAttachment(with: imageData, url: url, completionHandler: { [weak self] (success, error) in
                guard success else {
                    return
                }
                cdcontent.uploadState = .finished
                cdmessage.content = cdcontent
                cd.save()
                
                message.content = content
                self?.sendMessage(message: message)
            })
        }
    }
    
    func sendPendingMessages() {
        coredata?.fetchPendingMessages(completion: { (cdMessages) in
            for cdMessage in cdMessages {
                guard let rawMessage = cdMessage.dictionaryValue(),
                    let message = Message(dictionary: rawMessage) else {
                        continue
                }
                self.sendMessage(message: message)
            }
        })
    }
    
    func sendMessage(sticker: StickerViewModel) {
        guard let content = ContentSticker(name: sticker.name,
                                           imageURL: sticker.imageURL.absoluteString,
                                           id: sticker.id,
                                           packID: sticker.packID) else { return }
        let message = buildMessage(with: content, type: .Sticker)
        sendMessage(message: message)
    }
    
    func sendMessage(image: UIImage) {
        
        //TODO: put this code inside publishmessage callback
        sendDataToRover()
    }
    
    private func sendMessage(message: Message) {
        //save to core data
        coredata?.buildMessage(message: message, status: .pending)
        coredata?.save()
        
        let trackerData = [
            sendMessageTrackerType.conversationID.rawValue : credential.conversationID,
            sendMessageTrackerType.messageType.rawValue : message.type.rawValue,
            sendMessageTrackerType.sender.rawValue : message.sender.id
        ]
        PrismAnalytics.shared.sendTracker(withEvent: .sendMessage, data: trackerData)
        
        //publish to mqtt
        PrismCore.shared.publishMessage(token: credential.accessToken, topic: credential.topic, messages: [message]) { [weak self] (message, error) in
            self?.sendDataToRover()
        }
    }
    
    private func buildMessage(with content: MessageContentMappable, type: MessageType) -> Message {
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
    
    @objc func reachabilityChanged(sender: Notification) {
        let reachability = sender.object as! ReachabilityHelper
        if reachability.isReachable {
            
            self.connect(completionHandler: { (success, error) in
                
            })
            
            if reachability.isReachableViaWiFi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        } else {
            print("Network not reachable")
        }
    }
    
    private func sendDataToRover() {
        guard UserDefaults.standard.bool(forKey: "isFirstMessage") || UserDefaults.standard.object(forKey: "isFirstMessage") == nil else {
            return
        }
        
        guard let credential = Vendor.shared.credential else {
            return
        }
        
        PrismAnalytics.shared.getIPAddress { (ipAddress) in
            let data : [String: Any] = [
                "device_id": UIDevice.current.identifierForVendor!,
                "conversation_id": credential.conversationID,
                "channel": "IOS-SDK",
                "public_ip_address": ipAddress,
                "sender_id": credential.sender.id,
                "sent_time": Int(floor(Date().timeIntervalSince1970))
            ]
            
            PrismAnalytics.shared.sendConversationDataToRover(data: data, token: credential.accessToken)
            UserDefaults.standard.set(false, forKey: "isFirstMessage")
        }
    }
    
    @objc func chatReceived(sender: Notification) {
        guard let message = sender.object as? Message else { return }

        coredata?.buildMessage(message: message, status: .sent)
        coredata?.save()

        if message.type == .CloseChat {
            UserDefaults.standard.set(true, forKey: "isFirstMessage")
        }
        
        coredata?.buildMessage(message: message, status: .sent)
    }
    
    @objc func chatDisconnect(sender: Notification) {
        
    }
    
    @objc func chatError(sender: Notification) {
        
    }
}
