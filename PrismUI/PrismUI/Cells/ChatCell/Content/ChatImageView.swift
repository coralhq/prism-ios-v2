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
    @IBOutlet var dimmedView: UIView!
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    
    var imageURL: URL?
    
    let imageHeight: CGFloat = 150
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.superview?.layer.masksToBounds = true
        imageView.superview?.layer.cornerRadius = 8
        
        NotificationCenter.default.addObserver(self, selector: #selector(uploadProgress(sender:)) , name: UploadProgressNotification, object: nil)
    }
    
    override func updateView(with viewModel: ChatViewModel) {
        guard let contentVM = viewModel.contentViewModel as? ContentImageViewModel,
            let state = contentVM.uploadState else {
                return
        }
        imageURL = contentVM.imageURL

        switch state {
        case .finished:
            dimmedView.isHidden = true
            indicatorView.stopAnimating()
        case .start: fallthrough
        default:
            dimmedView.isHidden = false
            indicatorView.startAnimating()
        }
        
        imageView.downloadedFrom(url: contentVM.imageURL)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func uploadProgress(sender: Notification) {
        
    }
}
