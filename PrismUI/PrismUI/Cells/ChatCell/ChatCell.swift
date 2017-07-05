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
    
    var viewModel: ChatViewModel? {
        didSet {
            chatView?.viewModel = viewModel
        }
    }
    
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
            break
        default:
            if viewModel.contentType == .Sticker {
                chatView = StickerOutContainer.containerFromNIB()
            } else {
                chatView = ChatOutContainerView.containerFromNIB()
            }
            break
        }
        
        switch viewModel.contentType {
        case .Cart:
            chatContentView = ChatCartView.viewFromNib() as? ChatContentProtocol
            break
        case .Invoice:
            chatContentView = ChatInvoiceView.viewFromNib() as? ChatContentProtocol
            break
        case .Product:
            chatContentView = ChatProductView.viewFromNib() as? ChatContentProtocol
            break
        case .Sticker:
            chatContentView = ChatStickerView.viewFromNib() as? ChatContentProtocol
            break
        case .Image:
            chatContentView = ChatImageView.viewFromNib() as? ChatContentProtocol
            break
        default:
            chatContentView = ChatTextView.viewFromNib() as? ChatContentProtocol
            break
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
