//
//  NetworkMock.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/29/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation
import UIKit

class NetworkMock: NetworkProtocol {
    
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
        let data = getMockData(object: mapToObject)
        let _ = endPoint.contentType
        let _ = endPoint.httpBody
        let _ = endPoint.url
        completionHandler(mapToObject.init(dictionary: data), nil)
    }
    
    fileprivate func getMockData<T: Mappable>(object: T.Type) -> [String: Any] {
        if object == ConnectResponse.self {
            return JSONResponseMock.connectResponse
        } else if object == Settings.self {
            return JSONResponseMock.getSettingsResponse
        } else if object == UploadURL.self {
            return JSONResponseMock.getAttachmentURLResponse
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
