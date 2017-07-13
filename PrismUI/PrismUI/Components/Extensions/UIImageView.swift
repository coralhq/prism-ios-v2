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
    
    var imageCache = NSCache<NSString, UIImage>()
}

extension UIImageView {
    
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        
        if let image = CacheVendor.shared.imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = image
        } else {
            URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                
                guard error == nil,
                    let image = UIImage(data: data!) else { return }
                
                DispatchQueue.main.async() { () -> Void in
                    CacheVendor.shared.imageCache.setObject(image, forKey: url.absoluteString as NSString)
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
