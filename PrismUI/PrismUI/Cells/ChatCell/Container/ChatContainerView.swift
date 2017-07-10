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
    @IBOutlet var topMarginConstraint: NSLayoutConstraint!
    
    static func containerFromNIB() -> ChatContainerView? {
        return self.viewFromNib() as? ChatContainerView
    }
    
    var chatContentView: ChatContentView?
    
    func update(with viewModel: ChatViewModel, isExtension: Bool) {
        chatContentView?.updateView(with: viewModel)
        
        infoView.timeLabel.text = viewModel.messageTime
        infoView.statusImageView?.image = viewModel.statusIcon
        
        chatContentView?.removeFromSuperview()
        
        if isExtension {
            nameLabel.text = nil
            topMarginConstraint.constant = 4
        } else {
            nameLabel.text = viewModel.senderName
            topMarginConstraint.constant = 10
        }
        
        updateInfoPosition()
        
        chatContentView?.addTo(view: containerView, margin: 0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()        
        
        infoView.statusImageView?.contentMode = .scaleAspectFit
    }
    
    func updateInfoPosition() {
        guard let infoPos = chatContentView?.infoPosition() else {
            return
        }
        switch infoPos {
        case .Left:
            infoWithContentHSpace.constant = 8
            infoWithContentVSpace.constant = 0
        case .Inside:
            infoWithContentHSpace.constant = -infoView.bounds.width
            infoWithContentVSpace.constant = 0
        default:
            infoWithContentHSpace.constant = -infoView.bounds.width
            infoWithContentVSpace.constant = -infoView.bounds.height
        }
    }
}
