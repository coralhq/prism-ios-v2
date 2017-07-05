//
//  ChatStickerView.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/19/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

class ChatStickerView: UIView {
    @IBOutlet var stickerImageView: UIImageView!
    
    var viewModel: ContentStickerViewModel? {
        didSet {
            guard let url = viewModel?.stickerURL else { return }
            stickerImageView.downloadedFrom(url: url)
        }
    }
    
    static func viewFromNib(with chatViewModel: ChatViewModel) -> ChatStickerView? {
        let view: ChatStickerView? = ChatStickerView.viewFromNib() as? ChatStickerView
        view?.viewModel = chatViewModel.contentViewModel as? ContentStickerViewModel
        return view
    }
}


extension ChatStickerView: ChatContentProtocol {
    func addTo(view: UIView?) {
        addTo(view: view, margin: 0)
    }
    
    func infoPosition() -> InfoViewPosition {
        return .Bottom
    }
}
