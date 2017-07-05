//
//  ChatTextView.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/18/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

class ChatTextView: UIView {
    
    var chatType: ChatCellType = .In
    
    static func viewFromNib(with type: ChatCellType) -> ChatTextView? {
        let view: ChatTextView? = ChatTextView.viewFromNib() as? ChatTextView
        view?.chatType = type
        return view
    }
    
    @IBOutlet var titleLabel: UILabel!
    
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
