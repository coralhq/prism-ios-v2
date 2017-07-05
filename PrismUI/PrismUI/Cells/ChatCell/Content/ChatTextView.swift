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
    var viewModel: ContentTextViewModel? {
        didSet {
            titleLabel.text = viewModel?.text
        }
    }
    
    static func viewFromNib(with chatViewModel: ChatViewModel) -> ChatTextView? {
        let view: ChatTextView? = ChatTextView.viewFromNib() as? ChatTextView
        view?.chatType = chatViewModel.cellType
        view?.viewModel = chatViewModel.contentViewModel as? ContentTextViewModel
        return view
    }
    
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
}
