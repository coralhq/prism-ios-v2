//
//  Settings.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/15/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation

class OfflineWidget {
    var equalsTitleMinimized: Bool? = false
    var equalsTitleExpanded: Bool? = false
    var titleExpanded: String? = ""
    var titleMinimized: String? = ""
    var offlineMessage: String? = ""
    var offlineMessageConfirmation: String? = ""
    var offlineForm = OfflineFormSettings()
    
    init() {}
    
    func configure(settings: [String: Any]) {
        guard let widget = settings["widget"] as? [String: Any],
            let appearance = widget["offline_widget"] as? [String: Any],
            let texts = appearance["texts"] as? [String: Any] else {
                return
        }
        
        equalsTitleMinimized = texts["equals_title_minimized"] as? Bool
        equalsTitleExpanded = texts["equals_title_expanded"] as? Bool
        titleExpanded = texts["title_expanded"] as? String
        titleMinimized = texts["title_minimized"] as? String
        offlineMessage = texts["offline_message"] as? String
        offlineMessageConfirmation = texts["offline_message_confirmation"] as? String
        
        offlineForm.configure(settings: settings)
    }
}

class WorkingHour {
    var isOnWorkingHour = false
    
    init() {}
    
    func configure(settings: [String: Any]) {
        let df = DateFormatter()
        df.dateFormat = "EEEE"
        let currentDay = df.string(from: Date()).lowercased()
        
        guard let widget = settings["widget"] as? [String: Any],
            let workHours = widget["working_hours"] as? [String: Any],
            let workTimes = workHours[currentDay] as? [[String: Any]] else {
                return
        }

        for workTime in workTimes {
            guard let fromTime = workTime["from"] as? String,
                let toTime = workTime["to"] as? String,
                let fromMinutes = fromTime.minutes(),
                let toMinutes = toTime.minutes() else {
                    continue
            }
            
            let cal = Vendor.shared.calendar
            let hour = cal.component(.hour, from: Date())
            let minute = cal.component(.minute, from: Date())
            let currentMinutes = hour * 60 + minute
            
            if currentMinutes > fromMinutes &&
                currentMinutes < toMinutes {
                isOnWorkingHour = true
            }
        }
    }
}

class Texts {
    var subtitle: String? = ""
    var titleExpanded: String? = ""
    var titleMinimized: String? = ""
    var welcomeMessage: String? = ""
    
    init() {}
    
    func configure(settings: [String: Any]) {
        guard let widget = settings["widget"] as? [String: Any],
            let appearance = widget["appearance"] as? [String: Any],
            let texts = appearance["texts"] as? [String: Any] else {
                return
        }
        
        subtitle = texts["subtitle"] as? String
        titleExpanded = texts["title_expanded"] as? String
        titleMinimized = texts["title_minimized"] as? String
        welcomeMessage = texts["welcome_message"] as? String
    }
}

class Persona {
    var enabled: Bool = false
    var name: String? = nil
    var imageURL: URL? = nil
    
    init() {}
    
    func configure(settings: [String: Any]) {
        guard let widget = settings["widget"] as? [String: Any],
        let appearance = widget["appearance"] as? [String: Any],
        let persona = appearance["persona"] as? [String: Any] else {
            return
        }
        
        enabled = persona["enabled"] as! Bool
        name = persona["name"] as? String
        if let stringURL = persona["image_url"] as? String {
            imageURL = URL(string: stringURL)
        }
    }
}

open class Settings {
    var texts = Texts()
    var theme: Theme = Theme()
    var connectForm: InputFormSettings = InputFormSettings()
    var workingHour = WorkingHour()
    var persona = Persona()
    var offlineWidget = OfflineWidget()
    
    static public var shared = Settings()
    
    func configure(settings: [String: Any]) {
        theme.configure(option: ThemeType(settings: settings))
        connectForm.configure(settings: settings)
        workingHour.configure(settings: settings)
        persona.configure(settings: settings)
        texts.configure(settings: settings)
        offlineWidget.configure(settings: settings)
    }
}
