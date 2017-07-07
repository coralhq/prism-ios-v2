//
//  TextViewModel.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 7/5/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import PrismCore

class ContentViewModel {}

class TextViewModel: ContentViewModel {
    var text: String
    
    init(contentText: ContentPlainText) {
        text = contentText.text
    }
}
