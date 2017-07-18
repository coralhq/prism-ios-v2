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
    
    var chatType: ChatCellType = .In

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if chatType == .In {
            titleLabel.textAlignment = .left
        } else {
            titleLabel.textAlignment = .right
        }
    }
    
    override func infoPosition() -> InfoViewPosition {
        return .Bottom
    }
    override func updateView(with viewModel: ChatViewModel) {
        chatType = viewModel.cellType
        
        if let vm = viewModel.contentViewModel as? ContentTextViewModel {
            titleLabel.text = vm.text
        } else if let vm = viewModel.contentViewModel as? ContentOfflineViewModel {
            titleLabel.text = vm.text
        }
    }
}
