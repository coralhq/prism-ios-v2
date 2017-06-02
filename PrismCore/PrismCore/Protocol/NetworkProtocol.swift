//
//  NetworkProtocol.swift
//  PrismCore
//
//  Created by Nanang Rafsanjani on 5/24/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

protocol NetworkProtocol {
    func requestRawResult<T: Mappable>(endPoint: EndPoint, mapToObject: T.Type, completionHandler: @escaping (([String: Any]?, Error?) -> ()))
    
    func request<T: Mappable>(endPoint: EndPoint, mapToObject: T.Type, completionHandler: @escaping HTTPRequestResult)
    
    func connectToBroker(username: String, password: String, completionHandler: @escaping ((Bool, Error?) -> ()))
    
    func subscribeToTopic(topic: String, completionHandler: @escaping ((Bool, Error) -> ()))
    
    func publishMessage(topic: String, message: Message, completionHandler: @escaping (Message?, Error?) -> ())
    
    func setMQTTDelegate(delegate: MQTTSessionDelegate)
    
    func disconnectFromBroker(completionHandler: ((Bool)->()))
}
