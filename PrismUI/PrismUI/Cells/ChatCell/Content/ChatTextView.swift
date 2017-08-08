//
//  ChatTextView.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/18/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

class ChatTextView: ChatContentView {
    @IBOutlet var titleLabel: UILabel!
    
    override func updateView(with viewModel: ChatViewModel) {
        
        if let vm = viewModel.contentViewModel as? ContentTextViewModel {
            titleLabel.text = vm.text
        } else if let vm = viewModel.contentViewModel as? ContentOfflineViewModel {
            titleLabel.text = vm.text
        }

        calculateContentWidth(label: titleLabel, supportLeft: true)
    }
}
