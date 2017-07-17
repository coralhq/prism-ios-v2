//
//  ChatStickerView.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/19/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

class ChatStickerView: ChatContentView {
    @IBOutlet var stickerImageView: UIImageView!
    
    override func infoPosition() -> InfoViewPosition {
        return .Bottom
    }
    override func updateView(with viewModel: ChatViewModel) {
        guard let contentVM = viewModel.contentViewModel as? ContentStickerViewModel,
            let url = contentVM.stickerURL else { return }
        stickerImageView.downloadedFrom(url: url)
    }
}
