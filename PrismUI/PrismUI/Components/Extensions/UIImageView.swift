//
//  UIImageView.swift
//  PrismUI
//
//  Created by fanni suyuti on 6/12/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation

class CacheVendor {
    static var shared = CacheVendor()
    let cacheImages = NSCache<NSString, UIImage>()
}

extension UIImageView {
    
    func downloadedFrom(url: URL?, defaultImage: UIImage? = nil, contentMode: UIViewContentMode = .scaleAspectFill) {
        self.contentMode = contentMode
        self.image = defaultImage
        
        guard let url = url else {
            return
        }
        
        let key = url.absoluteString
        
        if let image = CacheVendor.shared.cacheImages.object(forKey: key as NSString) {
            self.image = image
        } else {
            URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                DispatchQueue.main.async {
                    guard error == nil,
                        let image = UIImage(data: data!) else {
                            return
                    }
                    CacheVendor.shared.cacheImages.setObject(image, forKey: url.absoluteString as NSString)
                    self?.image = image
                }
                }.resume()
        }
    }
    
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
