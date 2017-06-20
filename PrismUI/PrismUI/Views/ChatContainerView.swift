//
//  ChatContainerView.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/19/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

enum InfoViewPosition {
    case Bottom
    case Inside
    case Left
}

class ChatContainerView: UIView {
    @IBOutlet var infoView: UIView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var infoWithContentHSpace: NSLayoutConstraint!
    @IBOutlet var infoWithContentVSpace: NSLayoutConstraint!
    
    var chatContentView: ChatContentProtocol? {
        didSet {
            chatContentView?.addTo(view: containerView)
            updateInfoView()
        }
    }
    
    func updateInfoView() {
        guard let infoPos = chatContentView?.infoPosition() else { return }
        switch infoPos {
        case .Left:
            infoWithContentHSpace.constant = 8
            infoWithContentVSpace.constant = 0
            break
        case .Inside:
            infoWithContentHSpace.constant = -infoView.bounds.width
            infoWithContentVSpace.constant = 0
            break
        default:
            infoWithContentHSpace.constant = -infoView.bounds.width
            infoWithContentVSpace.constant = -infoView.bounds.height
            break
        }
    }
}
