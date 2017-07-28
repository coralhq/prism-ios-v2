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
    let coredata: CoreDataManager
    let reachability = ReachabilityHelper()!
    let prismCore: PrismCore = PrismCore()
    var credential: PrismCredential? {
        return Vendor.shared.credential
    }
    
    init(coreDatamanager: CoreDataManager) {
        self.coredata = coreDatamanager
        
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
        guard let credential = credential else {
            return
        }
        prismCore.connectToBroker(username: credential.username, password: credential.password) { [weak self] (success, error) in
            let topic = credential.topic
            self?.prismCore.subscribeToTopic(topic) { (success, error) in
                self?.sendPendingMessages()
                completionHandler(success, error)
            }
        }
    }
    
    func sendMessage(text: String) {
        guard let content = ContentPlainText(text: text) else { return }
        let message = newMessage(with: content, type: .PlainText)
        sendMessage(message: message, completion: nil)
    }
    
    func sendMessage(image: UIImage, imageName: String, state: AttachmentUploadState, uploadURL: URL? = nil, message: Message? = nil, cdmessage: CDMessage? = nil) {
        guard let credential = credential else {
            return
        }
        
        var cdmsg = cdmessage
        var msg = message
        
        if msg == nil {
            let content = ContentAttachment(name: imageName, mimeType: "image")
            msg = newMessage(with: content, type: .Attachment)
        }
        
        if cdmsg == nil {
            cdmsg = coredata.buildMessage(message: msg!, status: .pending)
        }
        
        guard let content = msg?.content as? ContentAttachment,
            let cdcontent = cdmsg?.content as? CDContentAttachment else {
                return
        }
        
        switch state {
        case .start:
            let tempURL = UUID().uuidString
            CacheImage.shared.store(image: image, key: tempURL)
            
            cdcontent.url = tempURL
            cdcontent.uploadState = state
            cdmsg?.content = cdcontent
            coredata.save()
            
            sendMessage(image: image, imageName: imageName, state: .uploading, message: msg, cdmessage: cdmsg)
            
        case .uploading:
            prismCore.getAttachmentURL(filename: imageName, conversationID: credential.conversationID, token: credential.accessToken) { [weak self] (response, error) in
                
                guard let upURL = response?.uploadURL,
                    let key = upURL.cleared?.absoluteString else {
                        return
                }
                
                CacheImage.shared.remove(key: key, completion: {
                    CacheImage.shared.store(image: image, key: key)
                })
                
                content.url = key
                
                cdcontent.url = key
                cdcontent.uploadState = state
                cdmsg?.content = cdcontent
                self?.coredata.save()
                
                self?.sendMessage(image: image,
                                 imageName: imageName,
                                 state: .finished,
                                 uploadURL: upURL,
                                 message: msg,
                                 cdmessage: cdmsg)
            }
        default:
            guard let imageData = UIImagePNGRepresentation(image),
                let upURL = uploadURL else {
                    return
            }
            prismCore.uploadAttachment(with: imageData, url: upURL, completionHandler: { [weak self] (success, error) in
                guard success else {
                    return
                }
                cdcontent.uploadState = state
                cdmsg?.content = cdcontent
                self?.coredata.save()
                
                msg?.content = content
                self?.sendMessage(message: msg!, completion: nil)
            })
        }
    }
    
    func sendPendingMessages() {
        coredata.fetchPendingMessages(completion: { [weak self] (cdMessages) in
            for cdMessage in cdMessages {
                guard let rawMessage = cdMessage.dictionaryValue(),
                    let message = Message(dictionary: rawMessage) else {
                        continue
                }
                if message.type == .Attachment {
                    guard let cdcontent = cdMessage.content as? CDContentAttachment,
                        let content = message.content as? ContentAttachment,
                        let stringURL = content.url else {
                            return
                    }
                    CacheImage.shared.fetch(key: stringURL, completion: { (image) in
                        guard let image = image else {
                            return
                        }
                        self?.sendMessage(image: image,
                                         imageName: content.name,
                                         state: cdcontent.uploadState,
                                         message: message,
                                         cdmessage: cdMessage)
                    })
                } else {
                    self?.sendMessage(message: message, completion: nil)
                }
            }
        })
    }
    
    func sendMessage(sticker: StickerViewModel) {
        guard let content = ContentSticker(name: sticker.name,
                                           imageURL: sticker.imageURL.absoluteString,
                                           id: sticker.id,
                                           packID: sticker.packID) else { return }
        let message = newMessage(with: content, type: .Sticker)
        sendMessage(message: message, completion: nil)
    }
    
    func sendOfflineMessage(with name: String, email: String, phone: String, message: String, completion: ((MessageResponse?, NSError?) -> ())?) {
        let content = ContentOfflineMessage(name: name, email: email, phone: phone, text: message)!
        let message = newMessage(with: content, type: .OfflineMessage)
        sendMessage(message: message, completion: completion)
    }
    
    func newMessage(with content: MessageContentMappable, type: MessageType) -> Message {
        let credential = Vendor.shared.credential!
        return Message(id: NSUUID().uuidString.lowercased(),
                       conversationID: credential.conversationID,
                       merchantID: credential.merchantID,
                       channel: PrismChannelName,
                       visitor: credential.visitorInfo,
                       sender: credential.sender,
                       type: type,
                       content: content,
                       brokerMetaData: BrokerMetaData())
    }
    
    private func sendMessage(message: Message, completion: ((MessageResponse?, NSError?) -> ())?) {
        guard let credential = credential else {
            return
        }
        
        //save to core data
        coredata.buildMessage(message: message, status: .pending)
        coredata.save()
        
        let trackerData = [
            sendMessageTrackerType.conversationID.rawValue : credential.conversationID,
            sendMessageTrackerType.messageType.rawValue : message.type.rawValue,
            sendMessageTrackerType.sender.rawValue : message.sender.id
        ]
        PrismAnalytics.shared.sendTracker(withEvent: .sendMessage, data: trackerData)
        
        //publish to mqtt
        prismCore.publishMessage(token: credential.accessToken, topic: credential.topic, messages: [message]) { [weak self] (message, error) in
            self?.sendDataToRover()
            completion?(message, error)
        }
    }
    
    @objc func reachabilityChanged(sender: Notification) {
        let reachability = sender.object as! ReachabilityHelper
        if reachability.isReachable {
            
            DispatchQueue.main.async {
                self.syncChatLocalWithServer()
                self.connect(completionHandler: { (success, error) in })
            }
            
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
                "device_id": UIDevice.current.identifierForVendor!.description,
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
    
    func syncChatLocalWithServer() {
        guard let credential = credential else {
            return
        }
        
        coredata.fetchLatestMessage(completion: { [weak self] (message) in
            let convID = credential.conversationID
            let token = credential.accessToken
            
            guard let timestamp = message.brokerMetaData?.timestamp else {
                return
            }
            let startTime = timestamp.timeIntervalSince1970.unixTime
            let endTime = Date().timeIntervalSince1970.unixTime

            self?.prismCore.getConversationHistory(conversationID: convID, token: token, startTime: startTime, endTime: endTime, completionHandler: { (history, error) in
                guard let messages = history?.messages else {
                    return
                }
                self?.coredata.saveMessages(messages: messages)
            })
        })
    }
    
    @objc func chatReceived(sender: Notification) {
        guard let message = sender.object as? Message else { return }
        
        coredata.buildMessage(message: message, status: .sent)
        coredata.save()
        
        if message.type == .CloseChat {
            UserDefaults.standard.set(true, forKey: "isFirstMessage")
        }
    }
    
    @objc func chatDisconnect(sender: Notification) {
        
    }
    
    @objc func chatError(sender: Notification) {
        
    }
}

extension URL {
    var cleared: URL? {
        var comp = URLComponents(url: self, resolvingAgainstBaseURL: false)
        comp?.query = nil
        comp?.fragment = nil
        return comp?.url
    }
}

extension TimeInterval {
    var unixTime: Int64 {
        return Int64(self * 1000)
    }
}
