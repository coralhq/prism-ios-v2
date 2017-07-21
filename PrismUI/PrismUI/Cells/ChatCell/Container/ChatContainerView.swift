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
    @IBOutlet var topMarginConstraint: NSLayoutConstraint!
    @IBOutlet var contentTrailing: NSLayoutConstraint?
    @IBOutlet var contentBottom: NSLayoutConstraint?
    @IBOutlet var infoTrailing: NSLayoutConstraint?
    @IBOutlet var infoBottom: NSLayoutConstraint?
    
    static func containerFromNIB() -> ChatContainerView? {
        return self.viewFromNib()
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
        
        nameLabel.textColor = Settings.shared.theme.buttonColor
        
        infoView.statusImageView?.contentMode = .scaleAspectFit
    }
    
    func updateInfoPosition() {
        guard let infoPos = chatContentView?.infoPosition() else {
            return
        }
        switch infoPos {
        case .Left:
            contentTrailing?.constant = infoView.bounds.width + 8 * 2
            contentBottom?.constant = 8
            infoTrailing?.constant = 8
            infoBottom?.constant = 8
        case .Inside:
            contentTrailing?.constant = 8
            contentBottom?.constant = 8
            infoTrailing?.constant = 8 * 2
            infoBottom?.constant = 8 * 2
        default:
            contentTrailing?.constant = 8
            contentBottom?.constant = infoView.bounds.height + 8 * 2
            infoTrailing?.constant = 8
            infoBottom?.constant = 8
        }
    }
}
