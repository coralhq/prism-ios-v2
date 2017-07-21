//
//  Settings.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/15/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation

class WorkingHour {
    var isOnWorkingHour = false
    
    init() { }
    
    func configure(settings: [String: Any]) {
        let df = Vendor.shared.dateFormatter
        df.dateFormat = "EEEE"
        let currentDay = df.string(from: Date()).lowercased()
        
        guard let widget = settings["widget"] as? [String: Any],
            let workHours = widget["working_hours"] as? [String: Any],
            let workTimes = workHours[currentDay] as? [[String: Any]],
            let timeZoneName = widget["timezone"] as? String,
            let timeZone = NSTimeZone(name: timeZoneName) else {
                return
        }
        
        for workTime in workTimes {
            let cal = Vendor.shared.calendar
            let component = cal.dateComponents(in: timeZone as TimeZone, from: Date())
            
            guard let fromTime = workTime["from"] as? String,
                let toTime = workTime["to"] as? String,
                let fromMinutes = fromTime.minutes(),
                let toMinutes = toTime.minutes(),
                let currentHour = component.hour,
                let currentMinute = component.minute else {
                    continue
            }
            
            let currentMinutes = currentHour * 60 + currentMinute
            if currentMinutes > fromMinutes &&
                currentMinutes < toMinutes {
                isOnWorkingHour = true
            }
        }
    }
}

class Persona {
    var enabled: Bool = false
    var name: String? = nil
    var imageURL: URL? = nil
    
    init() { }
    
    func configure(settings: [String: Any]) {
        guard let widget = settings["widget"] as? [String: Any] else {
            return
        }
        enabled = widget["persona_enabled"] as! Bool
        name = widget["persona_name"] as? String
        if let stringURL = widget["persona_image_url"] as? String {
            imageURL = URL(string: stringURL)
        }
    }
}

open class Settings {
    var subtitle: String? = ""
    var titleExpanded: String? = ""
    var titleMinimized: String? = ""
    var welcomeMessage: String? = ""
    var theme: Theme = Theme()
    var inputForm: InputFormSettings = InputFormSettings()
    var offlineFormMessage: String? = ""
    var offlineMessage: String? = ""
    var offlineForm: OfflineFormSettings = OfflineFormSettings()
    var workingHour = WorkingHour()
    var persona = Persona()
    
    static public var shared = Settings()
    
    func configure(settings: [String: Any]) {
        self.theme.configure(option: ThemeType(settings: settings))
        self.inputForm.configure(settings: settings)
        self.offlineForm.configure(settings: settings)
        self.workingHour.configure(settings: settings)
        self.persona.configure(settings: settings)
        
        guard let widget = settings["widget"] as? [String: Any] else {
            return
        }
        subtitle = widget["subtitle"] as? String
        titleExpanded = widget["title_expanded"] as? String
        titleMinimized = widget["title_minimized"] as? String
        welcomeMessage = widget["welcome_message"] as? String
        
        offlineMessage = widget["offline_message"] as? String
        offlineFormMessage = widget["offline_form_message"] as? String
    }
}
