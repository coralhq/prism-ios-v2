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
        
        PrismCore.shared.getAttachmentURL(filename: imageName, conversationID: self.credential.conversationID, token: self.credential.accessToken) { (response, error) in
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
            
            PrismCore.shared.uploadAttachment(with: imageData, url: url, completionHandler: { (success, error) in
                guard success else {
                    return
                }
                cdcontent.uploadState = .finished
                cdmessage.content = cdcontent
                cd.save()
                
                message.content = content
                
                PrismCore.shared.publishMessage(topic: self.credential.topic, message: message, completionHandler: { (message, error) in
                })
            })
        }
    }
    
    func sendMessage(sticker: StickerViewModel) {
        guard let content = ContentSticker(name: sticker.name,
                                           imageURL: sticker.imageURL.absoluteString,
                                           id: sticker.id,
                                           packID: sticker.packID) else { return }
        let message = buildMessage(with: content, type: .Sticker)
        sendMessage(message: message)
    }
    
    private func sendMessage(message: Message) {
        //save to core data
        coredata?.buildMessage(message: message, status: .pending)
        coredata?.save()
        
        //publish to mqtt
        PrismCore.shared.publishMessage(topic: credential.topic, message: message) { (message, error) in }
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
    
    @objc func chatReceived(sender: Notification) {
        guard let message = sender.object as? Message else { return }
        coredata?.buildMessage(message: message, status: .sent)
        coredata?.save()
    }
    
    @objc func chatDisconnect(sender: Notification) {
        
    }
    
    @objc func chatError(sender: Notification) {
        
    }
}
