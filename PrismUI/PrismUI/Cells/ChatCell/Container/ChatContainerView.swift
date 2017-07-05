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
    
    var viewModel: ChatViewModel! {
        didSet {
            infoView.timeLabel.text = viewModel.messageTime
            if viewModel.cellType == .Out {
                if viewModel.messageStatus == .sent {
                    infoView.statusImageView?.image = UIImage(named: "icStatusRead", in: Bundle.prism, compatibleWith: nil)
                } else {
                    infoView.statusImageView?.image = UIImage(named: "icStatusSending", in: Bundle.prism, compatibleWith: nil)
                }
            }
            
            nameLabel.text = viewModel.senderName
        }
    }
    
    var chatContentView: ChatContentProtocol? {
        didSet {
            chatContentView?.addTo(view: containerView)
            updateInfoView()
        }
    }

    static func viewFromNib(with viewModel: ChatViewModel) -> ChatContainerView? {
        let view: ChatContainerView = self.viewFromNib() as! ChatContainerView
        view.viewModel = viewModel
        return view
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
