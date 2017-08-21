//
//  ContentOfflineViewModel.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 7/18/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

class ContentOfflineViewModel: ContentViewModel {
    var text: String
    
    init(contentOfflineMessage: CDContentOfflineMessage) {
        text = contentOfflineMessage.text
    }
}
