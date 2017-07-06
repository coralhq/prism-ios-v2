//
//  ChatCell.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/17/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    var chatView: ChatContainerView?
    var chatContentView: ChatContentProtocol?

    static func reuseIdentifier(viewModel: ChatViewModel) -> String {
        return viewModel.contentType.rawValue + viewModel.cellType.rawValue
    }
    
    convenience init(viewModel: ChatViewModel) {
        self.init(style: .default, reuseIdentifier: ChatCell.reuseIdentifier(viewModel: viewModel))
        
        switch viewModel.cellType {
        case .In:
            if viewModel.contentType == .Sticker {
                chatView = StickerInContainer.containerFromNIB()
            } else {
                chatView = ChatInContainerView.containerFromNIB()
            }
        default:
            if viewModel.contentType == .Sticker {
                chatView = StickerOutContainer.containerFromNIB()
            } else {
                chatView = ChatOutContainerView.containerFromNIB()
            }
        }
        
        switch viewModel.contentType {
        case .Cart:
            chatContentView = ChatCartView.viewFromNib() as? ChatContentProtocol
        case .Invoice:
            chatContentView = ChatInvoiceView.viewFromNib() as? ChatContentProtocol
        case .Product:
            chatContentView = ChatProductView.viewFromNib() as? ChatContentProtocol
        case .Sticker:
            chatContentView = ChatStickerView.viewFromNib() as? ChatContentProtocol
        case .Image:
            chatContentView = ChatImageView.viewFromNib() as? ChatContentProtocol
        default:
            chatContentView = ChatTextView.viewFromNib() as? ChatContentProtocol
        }
        
        chatView?.addTo(view: contentView, margin: 0)
        chatView?.chatContentView = chatContentView
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = UIColor.clear
        backgroundView = UIView()
        selectedBackgroundView = UIView()
        
        transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum ChatCellType: String {
    case In = "_in"
    case Out = "_out"
}
