//
//  ChatTextView.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/18/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

class ChatTextView: UIView {
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
}

extension ChatTextView: ChatContentProtocol {
    func addTo(view: UIView?) {
        addTo(view: view, margin: 0)
    }
    
    func infoPosition() -> InfoViewPosition {
        return .Bottom
    }
    
    func updateView(with viewModel: ChatViewModel) {
        chatType = viewModel.cellType
        
        guard let vm = viewModel.contentViewModel as? ContentTextViewModel else { return }
        titleLabel.text = vm.text
    }
}
