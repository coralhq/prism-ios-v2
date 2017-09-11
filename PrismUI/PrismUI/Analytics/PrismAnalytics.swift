//
//  PrismAnalytics.swift
//  PrismAnalytics
//
//  Created by fanni suyuti on 7/5/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

public enum AnalyticEnvironment {
    case sandbox
    case production
    case staging
}

public enum EventTrackerType: String {
    case uploadImageClicked = "upload_image_clicked"
    case visitorConnect = "visitor_connect"
    case chatScreen = "chat_screen"
    case sendMessage = "message_sent"
}

public enum sendMessageTrackerType: String {
    case conversationID = "conversation_id"
    case sender = "sender"
    case messageType = "message_type"
}

open class PrismAnalytics {
    
    private var gai: GAI?
    private let network = Network()
    internal var environment: AnalyticEnvironment?
    private var ipAddress: String?
    
    private init() {
        guard let GAIInstance = GAI.sharedInstance() else {
            return
        }
        
        GAIInstance.tracker(withTrackingId: "UA-101925175-1")
        
        gai = GAIInstance
    }
    
    static open let shared = PrismAnalytics()
    
    open func configure(environment: AnalyticEnvironment) {
        self.environment = environment
        
        let url = URL(string: "https://api.ipify.org")!
        do {
            ipAddress = try String(contentsOf: url)
        } catch {}
    }
    
    open func sendConversationDataToRover(data: [String: Any], token: String) {
        network.request(data: data, token: token, url: URL.conversation)
    }
    
    open func sendDeviceInfoToRover(data: [String: Any], token: String) {
        network.request(data: data, token: token, url: URL.deviceInfo)
    }
    
    open func sendTracker(withEvent event: EventTrackerType, data: [String: String]? = nil) {
        guard let tracker = gai?.defaultTracker else { return }
        
        switch event {
        case .uploadImageClicked:
            guard let builder = GAIDictionaryBuilder.createEvent(withCategory: "custom_event", action: event.rawValue, label: nil, value: nil) else { return }
            tracker.send(builder.build() as [NSObject : AnyObject])
            
        case .chatScreen, .visitorConnect:
            tracker.set(kGAIScreenName, value: event.rawValue)
            guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
            tracker.send(builder.build() as [NSObject : AnyObject])
            
        case .sendMessage:
            guard let data = data else { return }
            
            let keys = data.flatMap({ $0.0 as String})
            for key in keys {
                tracker.set(key, value: data[key])
            }
            
            guard let builder = GAIDictionaryBuilder.createEvent(withCategory: "custom_event", action: event.rawValue, label: nil, value: nil) else { return }
            tracker.send(builder.build() as [NSObject : AnyObject])
        }
    }
    
    open func getIPAddress(completionHandler:((String)->())) {
        network.getIPAddress { (value) in
            completionHandler(value)
        }
    }
    
    open func dispatch() {
        gai?.dispatch()
    }
}
