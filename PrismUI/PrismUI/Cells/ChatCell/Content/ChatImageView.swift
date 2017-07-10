//
//  ChatImageView.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/20/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import PrismCore

class ChatImageView: ChatContentView {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var dimmedViewHeight: NSLayoutConstraint!
    
    var imageURL: URL?
    
    let imageHeight: CGFloat = 150
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.superview?.layer.masksToBounds = true
        imageView.superview?.layer.cornerRadius = 8
        
        dimmedViewHeight.constant = 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(uploadProgress(sender:)) , name: UploadProgressNotification, object: nil)
    }
    override func infoPosition() -> InfoViewPosition {
        return .Bottom
    }
    override func updateView(with viewModel: ChatViewModel) {
        guard let contentVM = viewModel.contentViewModel as? ContentImageViewModel,
            let state = contentVM.uploadState else {
                return
        }
        imageURL = contentVM.imageURL
        
        switch state {
        case .start:
            dimmedViewHeight.constant = imageHeight
        case .finished:
            dimmedViewHeight.constant = 0
        default: break
        }
        
        if let imageURL = contentVM.imageURL {
            imageView.downloadedFrom(url: imageURL)
        } else {
            imageView.image = contentVM.tempImage
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func uploadProgress(sender: Notification) {
        guard let url = sender.userInfo?["url"] as? NSURL,
            let progress = sender.userInfo?["progress"] as? Double else {
                return
        }
        if url.absoluteString == imageURL?.absoluteString {
            dimmedViewHeight.constant = imageHeight - (imageHeight * CGFloat(progress))
        }
    }
}
