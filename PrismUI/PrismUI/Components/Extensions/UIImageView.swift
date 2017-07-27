//
//  UIImageView.swift
//  PrismUI
//
//  Created by fanni suyuti on 6/12/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation

extension UIImageView {
    
    func downloadedFrom(url: URL?, defaultImage: UIImage? = nil, contentMode: UIViewContentMode = .scaleAspectFill) {
        self.contentMode = contentMode
        self.image = defaultImage
        
        guard let url = url else {
            return
        }
        
        let key = url.absoluteString
        
        CacheImage.shared.fetch(key: key) { [unowned self] (image) in
            if let image = image {
                self.image = image
            } else {
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    DispatchQueue.main.async {
                        guard let data = data,
                            let image = UIImage(data: data) else {
                                return
                        }
                        CacheImage.shared.store(image: image, key: key)
                        self.image = image
                    }}.resume()
            }
        }
    }
    
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
