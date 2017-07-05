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
    
    static func reuseIdentifier(viewModel: ChatViewModel, cellType: ChatCellType) -> String {
        return viewModel.contentType.rawValue + cellType.rawValue
    }
    
    convenience init(viewModel: ChatViewModel, cellType: ChatCellType) {
        self.init(style: .default, reuseIdentifier: ChatCell.reuseIdentifier(viewModel: viewModel, cellType: cellType))
        
        switch cellType {
        case .In:
            if viewModel.contentType == .Sticker {
                chatView = StickerInContainer.viewFromNib() as? ChatContainerView
            } else {
                chatView = ChatInContainerView.viewFromNib() as? ChatContainerView
            }
            break
        default:
            if viewModel.contentType == .Sticker {
                chatView = StickerOutContainer.viewFromNib() as? ChatContainerView
            } else {
                chatView = ChatOutContainerView.viewFromNib() as? ChatContainerView
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
            chatContentView = ChatTextView.viewFromNibWithType(type: cellType)
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
