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

class ChatInfoView: UIView {
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var statusImageView: UIImageView?
}

class ChatContainerView: UIView {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var infoView: ChatInfoView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var infoWithContentHSpace: NSLayoutConstraint!
    @IBOutlet var infoWithContentVSpace: NSLayoutConstraint!
    
    static func containerFromNIB() -> ChatContainerView? {
        return self.viewFromNib() as? ChatContainerView
    }
    
    var viewModel: ChatViewModel? {
        didSet {
            guard let vm = viewModel else { return }
            
            infoView.timeLabel.text = vm.messageTime
            infoView.statusImageView?.image = vm.statusIcon
            nameLabel.text = vm.senderName
            
            chatContentView?.updateView(with: vm)
        }
    }
    
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
