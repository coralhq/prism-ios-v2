//
//  PrismCoreSDK.swift
//  PrismCoreSDK
//
//  Created by fanni suyuti on 5/18/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

public let PrismChannelName = "IOS_SDK"

public typealias HTTPRequestResult = (Mappable?, NSError?) -> ()

public let ReceiveChatNotification = NSNotification.Name(rawValue: "ReceiveChatNotification")
public let DisconnectChatNotification = NSNotification.Name(rawValue: "ConnectChatNotification")
public let ErrorChatNotification = NSNotification.Name(rawValue: "ErrorChatNotification")
public let UploadProgressNotification = NSNotification.Name(rawValue: "UploadProgressNotification")
public let RefreshTokenNotification = NSNotification.Name("RefreshTokenNotification")

open class PrismCore {
    
    public weak var delegate: PrismCoreDelegate?
    
    static open var shared = PrismCore()
    
    internal var network: NetworkProtocol = Network()

    open func configure(environment: EnvironmentType, merchantID: String) {
        Config.shared.configure(environment: environment, merchantID: merchantID)
        
        if let network = network as? Network {
            network.configure()
        }
        
        network.delegate = self
        network.setMQTTDelegate(delegate: self)
    }
    
    public init() {}
    
    deinit {
        network.disconnectFromBroker(completionHandler: { (success) in })
        print("Prism Core De-Initialized")
    }
    
    open func visitorConnect(userName: String, userID: String, completionHandler: @escaping (ConnectResponse?, NSError?) -> ()) {
        let endPoint = VisitorConnectEndPoint(visitorName: userName, userID: userID)
        network.request(endPoint: endPoint, mapToObject: ConnectResponse.self) { (mappable, error) in
            DispatchQueue.main.async(){
                completionHandler(mappable as? ConnectResponse, error)
            }
        }
    }
    
    open func annonymousVisitorConnect(completionHandler: @escaping (ConnectResponse?, NSError?) -> ()) {
        let visitorName = String.randomVisitorName
        let userID = String.randomUserID
        
        let endPoint = VisitorConnectEndPoint(visitorName: visitorName, userID: userID)
        network.request(endPoint: endPoint, mapToObject: ConnectResponse.self) { (mappable, error) in
            DispatchQueue.main.async(){
                completionHandler(mappable as? ConnectResponse, error)
            }
        }
    }
    
    open func createConversation(visitorName: String, token: String, completionHandler: @escaping ((CreateConversationResponse? ,NSError?) -> ())) {
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
    
    open func publishMessage(token: String, topic: String, messages: [Message], completionHandler: @escaping (MessageResponse?, NSError?) -> ()) {
        let endPoint = PublishMessageEndPoint(token: token, messages: messages, topic: topic)
        
        network.request(endPoint: endPoint, mapToObject: MessageResponse.self) { (mappable, error) in
            completionHandler(mappable as? MessageResponse, error)
        }
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
    
    open func getConversationHistory(conversationID: String, token: String, startTime: Int64, endTime: Int64, completionHandler: @escaping ((ConversationHistory?, Error?) -> ())) {
        let endPoint = GetConversationHistoryEndPoint(conversationID: conversationID, token: token, startTime: startTime, endTime: endTime)

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
        do {
            guard let messageDict = try JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0)) as? [String: Any],
                let message = Message(dictionary: messageDict) else {
                    print("Error parsing MQTT message")
                    return
            }
            NotificationCenter.default.post(name: ReceiveChatNotification, object: message)
        } catch {
            NotificationCenter.default.post(name: ErrorChatNotification, object: error)
        }
    }
    
    internal func mqttDidDisconnect(session: MQTTSession) {
        NotificationCenter.default.post(name: DisconnectChatNotification, object: nil)
    }
    
    internal func mqttSocketErrorOccurred(session: MQTTSession) {
        NotificationCenter.default.post(name: ErrorChatNotification, object: nil)
    }
}

extension PrismCore: NetworkDelegate {
    func network(network: Network, uploadIn progress: Double, with stringURL: URL) {
        NotificationCenter.default.post(name: UploadProgressNotification,
                                        object: nil,
                                        userInfo: ["progress": progress, "url": stringURL])
    }
}
