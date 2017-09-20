//
//  URL.swift
//  PrismAnalytics
//
//  Created by fanni suyuti on 7/13/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation
import PrismCore

extension URL {
    
    private static var PrismAPIBaseURL: String {
        get {
            
            guard let environment = PrismAnalytics.shared.environment else {
                assert(PrismAnalytics.shared.environment != nil, "should configure PrismAnalytic first, call PrismAnalytics.shared.configure()")
                return ""
            }
            
            switch environment {
            case .production:
                return "https://api.prismapp.io/v2/metrics"
            case .sandbox:
                return "https://api.prismapp.io/v2/metrics"
            }
        }
    }
    
    static var ipifyAPI: URL {
        get {
            return URL(string: "https://api.ipify.org")!
        }
    }
    
    static var conversation: URL {
        get {
            return URL(string: PrismAPIBaseURL + "/conversations")!
        }
    }
    
    static var deviceInfo: URL {
        get {
            return URL(string: PrismAPIBaseURL + "/devices/ios")!
        }
    }
}
