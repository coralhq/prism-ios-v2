//
//  URL.swift
//  PrismCoreSDK
//
//  Created by fanni suyuti on 5/19/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

private class URLProvider {
    let baseURL: String
    let mqttPort: UInt16
    let mqttURL: String
    
    init(env: EnvironmentType) {
        switch env {
        case .production:
            baseURL = "https://api.prismapp.io"
            mqttURL = "chat.prismapp.io"
            mqttPort = 1883
        case .sandbox:
            baseURL = "https://api.prismapp.io"
            mqttURL = "chat.prismapp.io"
            mqttPort = 1883
        }
    }
}
    
internal extension URL {
    private static var provider: URLProvider {
        return URLProvider(env: Config.shared.getEnvironment() ?? .sandbox)
    }
    
    static var PrismAPIBaseURL: String { return provider.baseURL }
    
    static var PrismMQTTPort: UInt16 { return provider.mqttPort }
    
    static var PrismMQTTURL: String { return provider.mqttURL }
    
    static var prismConnect: URL {
        get {
            return URL(string: "\(PrismAPIBaseURL)/v2/visitors/connect")!
        }
    }
    
    static var publishMessage: URL {
        get {
            return URL(string: "\(PrismAPIBaseURL)/v2/new_messages")!
        }
    }
    
    static var refreshToken: URL {
        get {
            return URL(string: "\(PrismAPIBaseURL)/v2/token/refresh")!
        }
    }
    
    static var createConversation: URL {
        get {
            return URL(string: "\(PrismAPIBaseURL)/v2/conversations")!
        }
    }
    
    static var getSettings: URL {
        get {
            return URL(string: "\(PrismAPIBaseURL)/v2/settings?merchant_id=\(Config.shared.getMerchantID()!)")!
        }
    }
    
    static var getStickers: URL {
        get {
            return URL(string: "\(PrismAPIBaseURL)/v2/stickers/packs")!
        }
    }
    
    static func sendDeviceToken(visitorID: String) -> URL {
        return URL(string: "\(PrismAPIBaseURL)/v2/visitors/\(visitorID)/device")!
    }
    
    static func getAttachmentURL(conversationID: String) -> URL {
        return URL(string: "\(PrismAPIBaseURL)/v2/conversations/\(conversationID)/upload_url")!
    }
    
    static func getConversationHistory(conversationID: String, startTime: Int64, endTime: Int64) -> URL {
        return URL(string: "\(PrismAPIBaseURL)/v2/conversations_history/\(conversationID)/messages?start_time=\(startTime)&end_time=\(endTime)")!
    }
}
