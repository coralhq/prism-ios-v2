//
//  CacheImage.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 7/27/17.
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
            try FileManager.default.createDirectory(atPath: cachePath(), withIntermediateDirectories: true, attributes: nil)
        } catch {
            
        }
    }
    
    func remove(key: String, completion: (() -> ())? = nil) {
        opQueue.async { [unowned self] in
            let fileName = key.md5
            self.memCache.removeObject(forKey: fileName as NSString)
            let imgPath = self.imagePath(fileName: fileName)
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
            }
        }
    }
    
    private func imagePath(fileName: String) -> String {
        return cachePath() + "/" + fileName
    }
    
    func cachePath() -> String {
        guard let cachePath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return ""
        }
        return cachePath.appendingPathComponent("prism_images").path //.path// + "/prism_images"
    }
}
