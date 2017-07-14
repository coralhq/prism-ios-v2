//
//  Network.swift
//  PrismAnalytics
//
//  Created by fanni suyuti on 7/13/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

enum RoverType {
    case Conversation
    case DeviceInfo
}

class Network {
    func request(data: [String: Any], token: String, url: URL) {
        var request = URLRequest(url: url)
        
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        requestDataTask(request: request)
    }
    
    fileprivate func requestDataTask(request: URLRequest) {
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest)
        task.resume()
    }
    
    func getIPAddress(completionHandler:((String)->())) {
        let url = URL.ipifyAPI
        do {
            let ip = try String(contentsOf: url)
            completionHandler(ip)
        } catch {}
    }
}
