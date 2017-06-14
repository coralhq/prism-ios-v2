//
//  PrismCoreSDK.swift
//  PrismCoreSDK
//
//  Created by fanni suyuti on 5/18/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

public typealias HTTPRequestResult = (Mappable?, NSError?) -> ()

open class PrismCore {
    
    fileprivate var delegate: PrismCoreDelegate?
    
    static open var shared = PrismCore()
    
    private init() {}
    
    internal var network: NetworkProtocol = Network.shared
    
    open func configure(environment: EnvironmentType, merchantID: String, delegate: PrismCoreDelegate) {
        self.delegate = delegate
        Config.shared.configure(environment: environment, merchantID: merchantID)
        network.setMQTTDelegate(delegate: self)
    }    
    
    open func visitorConnect(userName: String, userID: String, completionHandler: @escaping (ConnectResponse?, NSError?) -> ()) {
        let endPoint = VisitorConnectEndPoint(visitorName: userName, userID: userID)
        network.request(endPoint: endPoint, mapToObject: ConnectResponse.self) { (mappable, error) in
            DispatchQueue.main.async(){
                completionHandler(mappable as? ConnectResponse, error)
            }
        }
    }
    
    open func annonymousVisitorConnect(completionHandler: @escaping (ConnectResponse?, Error?) -> ()) {        
        let visitorName = String.randomVisitorName
        let userID = String.randomUserID
        
        let endPoint = VisitorConnectEndPoint(visitorName: visitorName, userID: userID)
        network.request(endPoint: endPoint, mapToObject: ConnectResponse.self) { (mappable, error) in
            DispatchQueue.main.async(){
                completionHandler(mappable as? ConnectResponse, error)
            }
        }
    }
    
    open func createConversation(visitorName: String, token: String, completionHandler: @escaping ((CreateConversationResponse? ,Error?) -> ())) {
        let endPoint = CreateConversationEndPoint(visitorName: visitorName, token: token)
        
        network.request(endPoint: endPoint, mapToObject: CreateConversationResponse.self) { (mappable, error) in
            completionHandler(mappable as? CreateConversationResponse, error)
        }
    }
    
    open func connectToBroker(username: String, password: String, completionHandler: @escaping ((Bool, Error?) -> ())) {
        network.connectToBroker(username: username, password: password, completionHandler: completionHandler)
    }
    
    open func subscribeToTopic(_ topic: String, completionHandler: @escaping ((Bool, Error?) -> ())) {
        network.subscribeToTopic(topic: topic, completionHandler: completionHandler)
    }
    
    open func publishMessage(topic: String, message: Message, completionHandler: @escaping (Message?, Error?) -> ()) {
        network.publishMessage(topic: topic, message: message, completionHandler: completionHandler)
    }
    
    open func getSettings(completionHandler: @escaping ([String: Any]?, Error?) -> ()) {
        let endPoint = GetSettingsEndPoint()
        
        network.requestRawResult(endPoint: endPoint, mapToObject: Settings.self, completionHandler: completionHandler)
    }
    
    open func getStickers(token: String, completionHandler: @escaping ((StickerResponse?, Error?) -> ())) {
        let endPoint = GetStickersEndPoint(token: token)
        
        network.request(endPoint: endPoint, mapToObject: StickerResponse.self) { (mappable, error) in
            completionHandler(mappable as? StickerResponse, error)
        }
    }
    
    open func getAttachmentURL(filename: String, conversationID: String, token: String, completionHandler: @escaping ((UploadURL?, Error?) -> ())) {
        let endPoint = GetAttachmentURLEndPoint(filename: filename, conversationID: conversationID, token: token)
        
        network.request(endPoint: endPoint, mapToObject: UploadURL.self) { (mappable, error) in
            completionHandler(mappable as? UploadURL, error)
        }
    }
    
    open func uploadAttachment(with file:Data, url:URL, completionHandler: @escaping ((Bool, Error?) -> ())) {
        network.upload(attachment: file, url: url, completionHandler: completionHandler)
    }
    
    open func disconnectFromBroker(completionHandler: ((Bool) -> ())) {
        network.disconnectFromBroker { response in
            completionHandler(true)
        }
    }
    
    open func getConversationHistory(conversationID: String, token: String, completionHandler: @escaping ((ConversationHistory?, Error?) -> ())) {
        let endPoint = GetConversationHistoryEndPoint(conversationID: conversationID, token: token)
        
        network.request(endPoint: endPoint, mapToObject: ConversationHistory.self) { (mappable, error) in
            completionHandler(mappable as? ConversationHistory, error)
        }
    }
    
    open func unsubscribeFromTopic(topic: String, completionHandler: @escaping ((Bool, Error?) -> ())) {
        network.unsubscribeFromTopic(topic: topic) { (success, error) in
            completionHandler(success, error)
        }
    }
    
    open func refreshToken(clientID: String, refreshToken: String, completionHandler: @escaping ((RefreshTokenResponse?, Error?) -> ())) {
        let endPoint = RefreshTokenEndPoint(clientID: clientID, refreshToken: refreshToken)
        
        network.request(endPoint: endPoint, mapToObject: RefreshTokenResponse.self) { (response, error) in
            completionHandler(response as? RefreshTokenResponse, error)
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
