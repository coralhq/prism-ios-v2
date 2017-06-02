//
//  Network.swift
//  PrismCoreSDK
//
//  Created by fanni suyuti on 5/18/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case POST
    case PUT
    case GET
}

class Network: NetworkProtocol {
    
    static let shared = Network()
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
        var request = URLRequest(url: endPoint.url)
        
        if let token = endPoint.token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let contentType = endPoint.contentType {
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        }
        
        request.addValue("ApiVersion", forHTTPHeaderField: "ApiVersion")
        request.httpMethod = endPoint.method.rawValue
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: endPoint.httpBody, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        requestDataTask(request: request, mapToObject: mapToObject, completionHandler: completionHandler)
    }
    
    func upload(attachment: Data, url: URL, completionHandler: @escaping ((Bool, Error?) -> ())) {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.uploadTask(with: request, from: attachment) { (data, response, error) in
            DispatchQueue.main.async(){
                guard let httpResponse = response as? HTTPURLResponse else { return }
                completionHandler(httpResponse.statusCode == 200, error)
            }
        }
        task.resume()
    }
    
    fileprivate func requestDataTask<T: Mappable>(request: URLRequest, mapToObject: T.Type, completionHandler: @escaping HTTPRequestResult) {
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            if let _response = response {
                print("response \(_response)")
            }
            
            guard error == nil, let data = data else {
                DispatchQueue.main.async(){
                    completionHandler(nil, error)
                }
                return
            }
            
            do {
                
                if let data = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(data)
                    
                    DispatchQueue.main.async(){
                        completionHandler(mapToObject.init(dictionary: data), nil)
                    }
                }
                
            } catch let error {
                DispatchQueue.main.async(){
                    completionHandler(nil, error)
                }
            }
        })
        task.resume()
    }
    
    func setMQTTDelegate(delegate: MQTTSessionDelegate) {
        mqttSession.delegate = delegate
    }
    
    func connectToBroker(username: String, password: String, completionHandler: @escaping ((Bool, Error?) -> ())) {
        mqttSession.username = username
        mqttSession.password = password
        
        mqttSession.connect { (connected, error) in
            DispatchQueue.main.async(){
                completionHandler(connected, error)
            }
        }
    }
    
    func subscribeToTopic(topic: String, completionHandler: @escaping ((Bool, Error?) -> ())) {
        mqttSession.subscribe(to: topic, delivering: MQTTQoS.atLeastOnce) { (success, error) in
            DispatchQueue.main.async(){
                completionHandler(success, error)
            }
        }
    }
    
    func disconnectFromBroker(completionHandler: ((Bool) -> ())) {
        mqttSession.disconnect()
        completionHandler(true)
    }

    func unsubscribeFromTopic(topic: String, completionHandler: @escaping ((Bool, Error?) -> ())) {
        mqttSession.unSubscribe(from: topic) { (success, error) in
            DispatchQueue.main.async(){
                completionHandler(success, error)
            }
        }
    }
    
    func publishMessage(topic: String, message: Message, completionHandler: @escaping (Message?, Error?) -> ()) {
        
        let jsonData = try! JSONSerialization.data(withJSONObject: message.dictionaryValue, options: .prettyPrinted)
        
        mqttSession.publish(jsonData, in: topic, delivering: .atLeastOnce, retain: false) { (success, error) in
            DispatchQueue.main.async(){
                if success {
                    completionHandler(message, nil)
                } else {
                    completionHandler(nil, error)
                }
            }
        }
    }
}
