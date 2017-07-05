//
//  PrismAnalytics.swift
//  PrismAnalytics
//
//  Created by fanni suyuti on 7/5/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

public enum EventTrackerType: String {
    case uploadImageClicked = "upload_image_clicked"
    case visitorConnect = "visitor_connect"
    case chatScreen = "chat_screen"
}

open class PrismAnalytics {
    
    private var gai: GAI?
    
    private init() {
        guard let GAIInstance = GAI.sharedInstance() else {
            return
        }
        
        GAIInstance.tracker(withTrackingId: "UA-101925175-1")
        
        gai = GAIInstance
    }
    
    static open let shared = PrismAnalytics()
    
    open func sendTracker(withEvent event: EventTrackerType) {
        guard let tracker = gai?.defaultTracker else { return }
        
        var dictionaryBuilder: GAIDictionaryBuilder
        
        switch event {
        case .uploadImageClicked:
            guard let builder = GAIDictionaryBuilder.createEvent(withCategory: event.rawValue, action: event.rawValue, label: "", value: 1) else { return }
            dictionaryBuilder = builder
            
        default:
            tracker.set(kGAIScreenName, value: event.rawValue)
            guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
            dictionaryBuilder = builder
        }
        
        tracker.send(dictionaryBuilder.build() as [NSObject : AnyObject])
    }
}
