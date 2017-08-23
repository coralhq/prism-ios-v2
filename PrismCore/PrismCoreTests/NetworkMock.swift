//
//  NetworkMock.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/29/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation
import UIKit
import PrismCore

class TestConfig {
    static let shared = TestConfig()
    var isValidResponse = true
    
    private init() {}
}

class NetworkMock: NetworkProtocol {
    
    weak var delegate: NetworkDelegate?
    static let shared = NetworkMock()
    private let mqttSession = MQTTSession(host: "", port: 1882, clientID: "iOSDK", cleanSession: true, keepAlive: 60, useSSL: true)
    private init() {}
    
    func requestRawResult<T: Mappable>(endPoint: EndPoint, mapToObject: T.Type, completionHandler: @escaping (([String: Any]?, NSError?) -> ())) {
        
        request(endPoint: endPoint, mapToObject: mapToObject) { (mappable, error) in
            guard error == nil, let response = mappable as? Settings else {
                completionHandler(nil, error)
                return
            }
            
            completionHandler(response.data, nil)
        }
    }
    
    func request<T: Mappable>(endPoint: EndPoint, mapToObject: T.Type, completionHandler: @escaping HTTPRequestResult) {
        
        var data: [String: Any] = [:]
        if mapToObject == ConnectResponse.self {
            if let _ = mapToObject.init(dictionary: JSONResponseMock.connectResponseInvalidOAuth) {
                data = JSONResponseMock.connectResponseInvalidOAuth
            } else if let _ = mapToObject.init(dictionary: JSONResponseMock.connectResponseInvalidMQTT) {
                data = JSONResponseMock.connectResponseInvalidMQTT
            } else {
                data = JSONResponseMock.connectResponseInvalidVisitor
            }
        }
        
        if mapToObject == CreateConversationResponse.self {
            
            data = JSONResponseMock.createConverationResponseInvalidParticipant
            
            if let _ = mapToObject.init(dictionary: JSONResponseMock.createConverationResponseInvalidVisitor) {
                data.updateValue( JSONResponseMock.createConverationResponseInvalidVisitor, forKey: "mock")
            }
        }
        
        if mapToObject == StickerResponse.self {
            if let _ = mapToObject.init(dictionary: JSONResponseMock.getStickersResponseInvalidPack) {
                data = JSONResponseMock.getStickersResponseInvalidPack
            } else {
                data = JSONResponseMock.getStickersResponseInvalidStickers
            }
        }
        
        if mapToObject == SendTokenResponse.self {
            data = JSONResponseMock.sendTokenResponse
        }
        
        if mapToObject == MessageResponse.self {
            data = JSONResponseMock.getMessageResponse
        }
        
        var error: NSError? = NSError(domain: "", code: 0, userInfo: nil)
        if TestConfig.shared.isValidResponse {
            data = getValidResponse(object: mapToObject)
            error = nil
        }
        
        completionHandler(mapToObject.init(dictionary: data), error)
    }
    
    fileprivate func getValidResponse<T: Mappable>(object: T.Type) -> [String: Any] {
        if object == ConnectResponse.self {
            return JSONResponseMock.connectResponse
        } else if object == Settings.self {
            let mock = JSONResponseMock.getSettingsResponse
            let setting = Settings(dictionary: mock)
            guard setting?.dictionaryValue() != nil else { return [:]}
            
            return JSONResponseMock.getSettingsResponse
        } else if object == UploadURL.self {
            let result = JSONResponseMock.getAttachmentURLResponse
            let uploadURL = UploadURL(dictionary: result)
            return uploadURL!.dictionaryValue()
        } else if object == CreateConversationResponse.self {
            return JSONResponseMock.createConverationResponse
        } else if object == StickerResponse.self {
            return JSONResponseMock.getStickersResponse
        } else if object == ConversationHistory.self {
            return JSONResponseMock.getConversationHistoryResponse
        } else if object == RefreshTokenResponse.self {
            return JSONResponseMock.refreshTokenResponse
        }
        
        return [:]
    }
    
    func setMQTTDelegate(delegate: MQTTSessionDelegate) {
        mqttSession.delegate = delegate
    }
    
    func connectToBroker(username: String, password: String, completionHandler: @escaping ((Bool, NSError?) -> ())) {
        let connected = (JSONResponseMock.mqttPassword == password) &&
            (JSONResponseMock.mqttUsername == username)
        completionHandler(connected, nil)
    }
    
    func subscribeToTopic(topic: String, completionHandler: @escaping ((Bool, NSError?) -> ())) {
        let success = topic == JSONResponseMock.mqttTopic
        completionHandler(success, nil)
    }
    
    func upload(attachment: Data, url: URL, completionHandler: @escaping ((Bool, NSError?) -> ())) {
        let data = UIImagePNGRepresentation(JSONResponseMock.attachmentImage)
        let success = attachment == data
        completionHandler(success, nil)
    }
    
    func publishMessage(topic: String, message: Message, completionHandler: @escaping (Message?, NSError?) -> ()) {
        completionHandler(message, nil)
    }
    
    func disconnectFromBroker(completionHandler: ((Bool) -> ())) {
        completionHandler(true)
    }
  
    func unsubscribeFromTopic(topic: String, completionHandler: @escaping ((Bool, NSError?) -> ())) {
        completionHandler(true, nil)
    }
}
