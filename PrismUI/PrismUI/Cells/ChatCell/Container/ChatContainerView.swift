//
//  ChatContainerView.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/19/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

let chatBublePadding: CGFloat = 16
let chatContentPadding: CGFloat = 8

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
    
    var chatContentView: ChatContentView! {
        didSet {
            chatContentView.addTo(view: containerView, margin: 0)
        }
    }
    
    func update(with viewModel: ChatViewModel, isExtension: Bool) {
        chatContentView?.updateView(with: viewModel)
        
        infoView.timeLabel.text = Vendor.shared.getLocalDateWith(date: viewModel.messageTime, format: "hh:mm a")
        infoView.statusImageView?.image = viewModel.statusIcon
        
        if isExtension {
            nameLabel.text = nil
            topMarginConstraint.constant = 4
        } else {
            nameLabel.text = viewModel.senderName
            topMarginConstraint.constant = 10
        }
        
        updateInfoPosition()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.textColor = Settings.shared.theme.buttonColor
        
        infoView.statusImageView?.contentMode = .scaleAspectFit
    }
    
    func calculateInfoPosition() -> InfoViewPosition {
        guard let widthInfo = chatContentView.widthInfo else {
            return .Bottom
        }
        
        let maxContentWidth = chatContentView.contentConstraint.width
        let haveSpaceLeft = (widthInfo.lastWidth + infoView.bounds.width + chatContentPadding) < maxContentWidth
        if haveSpaceLeft {
            let haveSpaceInside = (widthInfo.widestWidth - widthInfo.lastWidth) > (infoView.bounds.width + chatContentPadding)
            if haveSpaceInside {
                return .Inside
            } else {
                return .Left
            }
        } else {
            return .Bottom
        }
    }
    
    func updateInfoPosition() {
        let position = calculateInfoPosition()
        switch position {
        case .Left:
            contentTrailing?.constant = infoView.bounds.width + chatContentPadding * 1.25
            contentBottom?.constant = chatContentPadding
            infoTrailing?.constant = chatContentPadding
            infoBottom?.constant = chatContentPadding
        case .Inside:
            contentTrailing?.constant = chatContentPadding
            contentBottom?.constant = chatContentPadding
            infoTrailing?.constant = chatContentPadding
            infoBottom?.constant = chatContentPadding
        default:
            contentTrailing?.constant = chatContentPadding
            contentBottom?.constant = infoView.bounds.height + chatContentPadding * 2
            infoTrailing?.constant = chatContentPadding
            infoBottom?.constant = chatContentPadding
        }
    }
}
