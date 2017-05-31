//
//  NetworkMock.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/29/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

//import XCTest
import Foundation

class NetworkMock: NetworkProtocol {
    
    static let shared = NetworkMock()
    private let mqttSession = MQTTSession(host: "", port: 1882, clientID: "iOSDK", cleanSession: true, keepAlive: 60, useSSL: true)
    private init() {}
    
    func requestRawResult<T: Mappable>(endPoint: EndPoint, mapToObject: T.Type, completionHandler: @escaping (([String: Any]?, Error?) -> ())) {
        
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
        
        completionHandler(mapToObject.init(json: data), nil)
    }
    
    fileprivate func getMockData<T: Mappable>(object: T.Type) -> [String: Any] {
        if object == ConnectResponse.self {
            return JSONResponseMock.connectResponse
        }
        
        return [:]
    }
    
    func setMQTTDelegate(delegate: MQTTSessionDelegate) {
        mqttSession.delegate = delegate
    }
    
    func connectToBroker(username: String, password: String, completionHandler: @escaping ((Bool, Error) -> ())) {
        mqttSession.username = username
        mqttSession.password = password
        
        mqttSession.connect { (connected, error) in
            completionHandler(connected, error)
        }
    }
    
    func subscribeToTopic(topic: String, completionHandler: @escaping ((Bool, Error) -> ())) {
        mqttSession.subscribe(to: topic, delivering: MQTTQoS.atLeastOnce) { (success, error) in
            completionHandler(success, error)
        }
    }
    
    func publishMessage(topic: String, message: Message, completionHandler: @escaping (Message?, Error?) -> ()) {
        
        let jsonData = try! JSONSerialization.data(withJSONObject: message.dictionaryValue, options: .prettyPrinted)
        
        mqttSession.publish(jsonData, in: topic, delivering: .atLeastOnce, retain: false) { (success, error) in
            if success {
                completionHandler(message, nil)
            } else {
                completionHandler(nil, error)
            }
        }
    }
}
