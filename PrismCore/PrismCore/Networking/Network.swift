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

class Network: NSObject, NetworkProtocol {
    
    static let shared = Network()
    
    var uploadTaskIdentifiers: [Int: URL] = [:]
    var delegate: NetworkDelegate?
    
    private let mqttSession: MQTTSession
    
    private var _urlSession: URLSession?
    private var urlSession: URLSession? {
        get {
            if _urlSession == nil {
                _urlSession = URLSession(configuration: URLSession.shared.configuration,
                                         delegate: self,
                                         delegateQueue: OperationQueue.main)
            }
            return _urlSession
        }
    }
    
    override init() {
        mqttSession = MQTTSession(host: URL.PrismMQTTURL,
                                  port: URL.PrismMQTTPort,
                                  clientID: "iOS-SDK",
                                  cleanSession: true,
                                  keepAlive: 60,
                                  useSSL: false)
        super.init()
    }
    
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
        var request = URLRequest(url: endPoint.url)
        
        if let token = endPoint.token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let contentType = endPoint.contentType {
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        }
        
        request.addValue("ApiVersion", forHTTPHeaderField: "ApiVersion")
        request.httpMethod = endPoint.method.rawValue
        
        if !endPoint.httpBody.isEmpty {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: endPoint.httpBody, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        if let messageEndPoint = endPoint as? PublishMessageEndPoint {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: messageEndPoint.messagesBody, options: .prettyPrinted)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        requestDataTask(request: request, mapToObject: mapToObject, completionHandler: completionHandler)
    }
    
    func upload(attachment: Data, url: URL, completionHandler: @escaping ((Bool, NSError?) -> ())) {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        let task = urlSession?.uploadTask(with: request, from: attachment) { (data, response, error) in
            DispatchQueue.main.async(){
                guard let httpResponse = response as? HTTPURLResponse else { return }
                completionHandler(httpResponse.statusCode == 200, error as NSError?)
            }
        }
        task?.resume()
        
        guard let identifier = task?.taskIdentifier else {
            return
        }
        var comp = URLComponents(url: url, resolvingAgainstBaseURL: false)
        comp?.query = nil
        comp?.fragment = nil
        uploadTaskIdentifiers[identifier] = comp?.url
    }
    
    fileprivate func requestDataTask<T: Mappable>(request: URLRequest, mapToObject: T.Type, completionHandler: @escaping HTTPRequestResult) {
        let task = urlSession?.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                DispatchQueue.main.async() {
                    if (error! as NSError).code == 401 {
                        NotificationCenter.default.post(name: RefreshTokenNotification, object: nil)
                    }
                    completionHandler(nil, error as NSError?)
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                let data = data else {
                    let error = NSError(
                        domain: NSURLErrorDomain,
                        code: NSURLErrorUnknown,
                        userInfo: nil
                    )
                    completionHandler(nil, error)
                    return
            }
            
            do {
                if let data = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    if response.statusCode >= 200 &&
                        response.statusCode <= 299 {
                        DispatchQueue.main.async(){
                            completionHandler(mapToObject.init(dictionary: data), nil)
                        }
                    } else {
                        let error = PrismError(
                            domain: "error.prismapp.io",
                            code: response.statusCode,
                            userInfo: [NSLocalizedDescriptionKey: data["message"] as Any,
                                       NSLocalizedFailureReasonErrorKey: data["data"] as Any]
                        )
                        DispatchQueue.main.async(){
                            completionHandler(nil, error)
                        }
                    }
                }
            } catch let error {
                DispatchQueue.main.async(){
                    completionHandler(nil, error as NSError?)
                }
            }
        })
        task?.resume()
    }
    
    func setMQTTDelegate(delegate: MQTTSessionDelegate) {
        mqttSession.delegate = delegate
    }
    
    func connectToBroker(username: String, password: String, completionHandler: @escaping ((Bool, NSError?) -> ())) {
        mqttSession.username = username
        mqttSession.password = password
        mqttSession.connect { (connected, error) in
            DispatchQueue.main.async(){
                completionHandler(connected, error as NSError?)
            }
        }
    }
    
    func subscribeToTopic(topic: String, completionHandler: @escaping ((Bool, NSError?) -> ())) {
        mqttSession.subscribe(to: topic, delivering: MQTTQoS.atLeastOnce) { (success, error) in
            DispatchQueue.main.async(){
                completionHandler(success, error as NSError?)
            }
        }
    }
    
    func disconnectFromBroker(completionHandler: ((Bool) -> ())) {
        mqttSession.disconnect()
        completionHandler(true)
    }
    
    func unsubscribeFromTopic(topic: String, completionHandler: @escaping ((Bool, NSError?) -> ())) {
        mqttSession.unSubscribe(from: topic) { (success, error) in
            DispatchQueue.main.async(){
                completionHandler(success, error as NSError?)
            }
        }
    }
    
    func publishMessage(topic: String, message: Message, completionHandler: @escaping (Message?, NSError?) -> ()) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: message.dictionaryValue(), options: .init(rawValue: 0))
            
            mqttSession.publish(jsonData, in: topic, delivering: .atLeastOnce, retain: false) { (success, error) in
                DispatchQueue.main.async(){
                    if success {
                        completionHandler(message, nil)
                    } else {
                        completionHandler(nil, error as NSError?)
                    }
                }
            }
        } catch {
            print("error \(error)")
        }
    }
}

extension Network: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
        guard let url = uploadTaskIdentifiers[task.taskIdentifier] else {
            return
        }
        let progress: Double = Double(totalBytesSent)/Double(totalBytesExpectedToSend)
        delegate?.network(network: self, uploadIn: progress, with: url)
    }
}

protocol NetworkDelegate: class {
    func network(network: Network, uploadIn progress: Double, with stringURL: URL)
}
