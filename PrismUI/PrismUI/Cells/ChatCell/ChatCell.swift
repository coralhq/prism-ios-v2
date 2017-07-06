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
    var chatContentView: UIView?
    
    static func reuseIdentifier(viewModel: ChatViewModel) -> String {
        return viewModel.contentType.rawValue + viewModel.cellType.rawValue
    }
    
    convenience init(viewModel: ChatViewModel) {
        self.init(style: .default, reuseIdentifier: ChatCell.reuseIdentifier(viewModel: viewModel))
        
        switch viewModel.cellType {
        case .In:
            if viewModel.contentType == .Sticker {
                chatView = StickerInContainer.viewFromNib(with: viewModel)
            } else {
                chatView = ChatInContainerView.viewFromNib(with: viewModel)
            }
            break
        default:
            if viewModel.contentType == .Sticker {
                chatView = StickerOutContainer.viewFromNib(with: viewModel)
            } else {
                chatView = ChatOutContainerView.viewFromNib(with: viewModel)
            }
            break
        }
        
        switch viewModel.contentType {
        case .Cart:
            chatContentView = ChatCartView.viewFromNib()
            break
        case .Invoice:
            chatContentView = ChatInvoiceView.viewFromNib()
            break
        case .Product:
            chatContentView = ChatProductView.viewFromNib()
            break
        case .Sticker:
            chatContentView = ChatStickerView.viewFromNib()
            break
        case .Image:
            chatContentView = ChatImageView.viewFromNib()
            break
        default:
            chatContentView = ChatTextView.viewFromNib(with: viewModel.cellType)
            break
        }
        
        chatView?.addTo(view: contentView, margin: 0)
        chatView?.chatContentView = chatContentView as? ChatContentProtocol
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
