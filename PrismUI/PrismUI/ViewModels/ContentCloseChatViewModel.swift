//
//  ContentCloseChatViewModel.swift
//  PrismUI
//
//  Created by fanni suyuti on 8/2/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import PrismCore

class ContentCloseChatViewModel: ContentViewModel {
    var text: String
    
    init(contentText: CDContentCloseChat) {
        text = contentText.text
    }
}
