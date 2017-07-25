//
//  UIImageView.swift
//  PrismUI
//
//  Created by fanni suyuti on 6/12/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation

class CacheImage {
    
    private let memCache = NSCache<NSString, UIImage>()
    private var opQueue: DispatchQueue {
        return DispatchQueue(label: "op_queue")
    }
    static var shared = CacheImage()
    
    init() {
        do {
            try FileManager.default.createDirectory(atPath: cachePath(), withIntermediateDirectories: true, attributes: nil)
        } catch {
        }
    }
    
    func clearCache() {
        do {
            try FileManager.default.removeItem(atPath: cachePath())
        } catch {
            
        }
    }
    
    func remove(key: String, completion: (() -> ())? = nil) {
        opQueue.async { [unowned self] in
            self.memCache.removeObject(forKey: key as NSString)
            let imgPath = self.imagePath(fileName: key.md5)
            do {
                try FileManager.default.removeItem(atPath: imgPath)
                DispatchQueue.main.async {
                    completion?()
                }
            } catch {
                DispatchQueue.main.async {
                    completion?()
                }
            }
        }
    }
    
    func store(image: UIImage, key: String, completion: (() -> ())? = nil) {
        let fileName = key.md5
        
        opQueue.async { [unowned self] in
            if let _ = self.memCache.object(forKey: fileName as NSString) {
                return
            }
            
            self.memCache.setObject(image, forKey: fileName as NSString)
            
            guard let data = UIImagePNGRepresentation(image) else {
                return
            }
            
            let imgPath = URL(fileURLWithPath: self.imagePath(fileName: fileName))
            do {
                try data.write(to: imgPath)
            } catch {
                print("Persist Error \(error)")
            }
            
            DispatchQueue.main.async {
                completion?()
            }
        }
    }
    
    func fetch(key: String, completion:((UIImage?) -> ())? = nil) {
        let fileName = key.md5
        
        opQueue.async { [unowned self] in
            if let img = self.memCache.object(forKey: fileName as NSString) {
                DispatchQueue.main.async {
                    completion?(img)
                }
                return
            }
            
            let imgPath = URL(fileURLWithPath: self.imagePath(fileName: fileName))
            do {
                let data = try Data(contentsOf: imgPath)
                if let img = UIImage(data: data) {
                    self.memCache.setObject(img, forKey: fileName as NSString)
                    self.store(image: img, key: fileName)
                    
                    DispatchQueue.main.async {
                        completion?(img)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion?(nil)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion?(nil)
                }
                print("Get Error \(error)")
            }
        }
    }
    
    private func imagePath(fileName: String) -> String {
        return cachePath() + fileName
    }
    
    func cachePath() -> String {
        guard let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            return ""
        }
        return cachePath + "/prism_images/"
    }
}

extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        if size.width < targetSize.width ||
            size.height < targetSize.height {
            return self
        }
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}

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
