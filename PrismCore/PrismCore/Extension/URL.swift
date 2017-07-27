//
//  URL.swift
//  PrismCoreSDK
//
//  Created by fanni suyuti on 5/19/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

internal extension URL {
    
    private static let PrismAPIBaseURLProduction = "https://api.prismapp.io"
    private static let PrismMQTTURLProduction = "chat.prismapp.io"
    private static let PrismMQTTPortProduction: UInt16 = 1883
    
    private static let PrismAPIBaseURLSandbox = "https://api.sandbox.prismapp.io"
    private static let PrismMQTTURLSandbox = "chat.sandbox.prismapp.io"
    private static let PrismMQTTPortSandbox: UInt16 = 1883
    
    private static let PrismAPIBaseURLStaging = "https://kong-feat-stg.prismapp.io"
    private static let PrismMQTTURLStaging = "mqtt-feat-stg.prismapp.io"
    private static let PrismMQTTPortStaging: UInt16 = 1883
    
    private static var PrismAPIBaseURL: String {
        get {
            switch Config.shared.getEnvironment()! {
            case .Production:
                return PrismAPIBaseURLProduction
            case .Sandbox:
                return PrismAPIBaseURLSandbox
            case .Staging:
                return PrismAPIBaseURLStaging
            }
        }
    }
    
    static var PrismMQTTPort: UInt16 {
        get {
            switch Config.shared.getEnvironment()! {
            case .Production:
                return PrismMQTTPortProduction
            case .Sandbox:
                return PrismMQTTPortSandbox
            case .Staging:
                return PrismMQTTPortStaging
            }
        }
    }
    
    static var PrismMQTTURL: String {
        get {
            switch Config.shared.getEnvironment()! {
            case .Production:
                return PrismMQTTURLProduction
            case .Sandbox:
                return PrismMQTTURLSandbox
            case .Staging:
                return PrismMQTTURLStaging
            }
        }
    }
    
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
    
    static func getAttachmentURL(conversationID: String) -> URL {
        return URL(string: "\(PrismAPIBaseURL)/v2/conversations/\(conversationID)/upload_url")!
    }
    
    static func getConversationHistory(conversationID: String, startTime: Int64, endTime: Int64) -> URL {
        return URL(string: "\(PrismAPIBaseURL)/v2/conversations_history/\(conversationID)/messages?start_time=\(startTime)&end_time=\(endTime)")!
    }
}
