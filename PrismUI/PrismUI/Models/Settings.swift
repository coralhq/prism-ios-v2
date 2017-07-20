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

open class Settings {
    var theme: Theme = Theme()
    var inputForm: InputFormSettings = InputFormSettings()
    var offlineForm: OfflineFormSettings = OfflineFormSettings()
    var workingHour = WorkingHour()
    
    static public var shared = Settings()
    
    func configure(settings: [String: Any]) {
        self.theme.configure(option: ThemeOptions(settings: settings))
        self.inputForm.configure(settings: settings)
        self.offlineForm.configure(settings: settings)
        self.workingHour.configure(settings: settings)
    }
}
