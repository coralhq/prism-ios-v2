//
//  PrismCoreSDK.swift
//  PrismCoreSDK
//
//  Created by fanni suyuti on 5/18/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

public typealias HTTPRequestResult = (Mappable?, Error?) -> ()

open class PrismCore {
    
    var delegate: PrismCoreDelegate?
    
    public init(environment: EnvironmentType, merchantID: String) {
        Config.shared.configure(environment: environment, merchantID: merchantID)
        Networking.shared.setMQTTDelegate(delegate: self)
    }
    
    open func visitorConnect(visitorName: String, userID: String, completionHandler: @escaping (ConnectResponse?, Error?) -> ()) {
        
        let endPoint = VisitorConnectEndPoint(visitorName: visitorName, userID: userID)
        Networking.shared.request(endPoint: endPoint, mapToObject: ConnectResponse.self) { (mappable, error) in
            DispatchQueue.main.async(){
                completionHandler(mappable as? ConnectResponse, error)
            }
        }
    }
    
    open func annonymousVisitorConnect(completionHandler: @escaping (ConnectResponse?, Error?) -> ()) {
        
        let visitorName = String.randomVisitorName
        let userID = String.randomUserID
        
        visitorConnect(visitorName: visitorName, userID: userID, completionHandler: completionHandler)
    }
    
    open func createConversation(visitorName: String, token: String, completionHandler: @escaping ((CreateConversationResponse? ,Error?) -> ())) {
        let endPoint = CreateConversationEndPoint(visitorName: visitorName, token: token)
        
        Networking.shared.request(endPoint: endPoint, mapToObject: CreateConversationResponse.self) { (mappable, error) in
            completionHandler(mappable as? CreateConversationResponse, error)
        }
    }
    
    open func connectToBroker(username: String, password: String, completionHandler: @escaping ((Bool, Error) -> ())) {
        Networking.shared.connectToBroker(username: username, password: password, completionHandler: completionHandler)
    }
    
    open func subscribeToTopic(_ topic: String, completionHandler: @escaping ((Bool, Error) -> ())) {
        Networking.shared.subscribeToTopic(topic: topic, completionHandler: completionHandler)
    }
    
    open func publishMessage(topic: String, message: Message, completionHandler: @escaping (Message?, Error?) -> ()) {
        Networking.shared.publishMessage(topic: topic, message: message, completionHandler: completionHandler)
    }
    
    open func getSettings(completionHandler: @escaping ([String: Any]?, Error?) -> ()) {
        let endPoint = GetSettingsEndPoint()
        
        Networking.shared.requestRawResult(endPoint: endPoint, mapToObject: Settings.self, completionHandler: completionHandler)
    }
    
    open func getStickers(token: String, completionHandler: @escaping ((StickerResponse?, Error?) -> ())) {
        let endPoint = GetStickersEndPoint(token: token)
        
        Networking.shared.request(endPoint: endPoint, mapToObject: StickerResponse.self) { (mappable, error) in
            completionHandler(mappable as? StickerResponse, error)
        }
    }
    
    open func getAttachmentURL(filename: String, conversationID: String, token: String, completionHandler: @escaping ((UploadURL?, Error?) -> ())) {
        let endPoint = GetAttachmentURLEndPoint(filename: filename, conversationID: conversationID, token: token)
        
        Networking.shared.request(endPoint: endPoint, mapToObject: UploadURL.self) { (mappable, error) in
            completionHandler(mappable as? UploadURL, error)
        }
    }
    
    open func getConversationHistory(conversationID: String, token: String, completionHandler: @escaping ((ConversationHistory?, Error?) -> ())) {
        let endPoint = GetConversationHistoryEndPoint(conversationID: conversationID, token: token)
        
        Networking.shared.request(endPoint: endPoint, mapToObject: ConversationHistory.self) { (mappable, error) in
            completionHandler(mappable as? ConversationHistory, error)
        }
    }
}

extension PrismCore: MQTTSessionDelegate {
    
    internal func mqttDidReceive(message data: Data, in topic: String, from session: MQTTSession) {
        delegate?.didReceive(message: data, in: topic)
    }
    
    internal func mqttDidDisconnect(session: MQTTSession) {
        
    }
    
    internal func mqttSocketErrorOccurred(session: MQTTSession) {
        
    }
}
