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
    private static let PrismAPIBaseURLSandbox = "https://kong.staging.coral-inc.com"
    private static let PrismMQTTURLProduction = "chat.prismapp.io"
    private static let PrismMQTTURLSandbox = "chat.prismapp.io"
    private static let PrismMQTTPortSandbox: UInt16 = 1883
    private static let PrismMQTTPortProduction: UInt16 = 1883
    
    private static var PrismAPIBaseURL: String {
        get {
            switch Config.shared.getEnvironment()! {
            case .Production:
                return PrismAPIBaseURLProduction
            case .Sandbox:
                return PrismAPIBaseURLSandbox
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
    
    static func getConversationHistory(conversationID: String) -> URL {
        return URL(string: "\(PrismAPIBaseURL)/v2/conversations_history/\(conversationID)/messages")!
    }
}
