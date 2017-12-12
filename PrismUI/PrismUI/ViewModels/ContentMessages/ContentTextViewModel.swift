//
//  ContentTextViewModel.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 7/5/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import PrismCore

class ContentViewModel {}

class ContentTextViewModel: ContentViewModel {
    var text: String
    
    init(contentText: CDContentPlainText) {
        text = contentText.text
    }
    
    init(contentAutoResponder: CDContentAutoResponder) {
        text = contentAutoResponder.text
    }
}
