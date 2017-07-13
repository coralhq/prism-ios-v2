//
//  NetworkProtocol.swift
//  PrismCore
//
//  Created by Nanang Rafsanjani on 5/24/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

protocol NetworkProtocol {
    func requestRawResult<T: Mappable>(endPoint: EndPoint, mapToObject: T.Type, completionHandler: @escaping (([String: Any]?, NSError?) -> ()))
    
    func request<T: Mappable>(endPoint: EndPoint, mapToObject: T.Type, completionHandler: @escaping HTTPRequestResult)
    
    func upload(attachment:Data, url:URL, completionHandler: @escaping ((Bool, NSError?) -> ())) -> Void
    
    func connectToBroker(username: String, password: String, completionHandler: @escaping ((Bool, NSError?) -> ()))
    
    func subscribeToTopic(topic: String, completionHandler: @escaping ((Bool, NSError?) -> ()))
    
    func unsubscribeFromTopic(topic: String, completionHandler: @escaping ((Bool, NSError?) -> ()))
    
    func setMQTTDelegate(delegate: MQTTSessionDelegate)
    
    func disconnectFromBroker(completionHandler: ((Bool)->()))
}
