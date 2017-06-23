//
//  ChatCell.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/17/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

enum ChatCellType: String {
    case In = "_in"
    case Out = "_out"
}

enum ChatContentType: String {
    case Text = "text_cell"
    case Sticker = "sticker_cell"
    case Cart = "cart_cell"
    case Invoice = "invoice_cell"
    case Product = "product_cell"
    case Image = "image_cell"
}

struct ChatCellConfig {
    let cellType: ChatCellType
    let contentType: ChatContentType
}

class ChatCell: UITableViewCell {
    var chatView: ChatContainerView?
    var chatContentView: UIView?
    
    static func reuseIdentifier(config: ChatCellConfig) -> String {
        return config.contentType.rawValue + config.cellType.rawValue
    }
    
    convenience init(config: ChatCellConfig) {
        self.init(style: .default, reuseIdentifier: ChatCell.reuseIdentifier(config: config))
        
        switch config.cellType {
        case .In:
            if config.contentType == .Sticker {
                chatView = StickerInContainer.viewFromNib() as? ChatContainerView
            } else {
                chatView = ChatInContainerView.viewFromNib() as? ChatContainerView
            }
            break
        default:
            if config.contentType == .Sticker {
                chatView = StickerOutContainer.viewFromNib() as? ChatContainerView
            } else {
                chatView = ChatOutContainerView.viewFromNib() as? ChatContainerView
            }
            break
        }
        
        switch config.contentType {
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
            chatContentView = ChatTextView.viewFromNibWithType(type: config.cellType)
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
