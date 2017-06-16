//
//  Settings.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/15/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation

open class Settings {
    var rawData: [String: Any] = [:]
    var theme: Theme = Theme()
    var inputForm: InputFormSettings = InputFormSettings()
    
    static public var shared = Settings()
    
    func configure(settings: [String: Any]) {
        guard let style = settings["style"] as? String,
            let themeOption = ThemeOptions(rawValue: style) else { return }
        self.rawData = settings
        self.theme.configure(option: themeOption)
        self.inputForm = InputFormSettings()
        self.inputForm.settings = settings
    }
}
