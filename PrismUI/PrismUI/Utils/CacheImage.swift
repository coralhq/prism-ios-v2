//
//  CacheImage.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 7/27/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import UIKit

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
        opQueue.async { [weak self] in
            guard let `self` = self else {
                return
            }
            let fileName = key.md5
            self.memCache.removeObject(forKey: fileName as NSString)
            do {
                try FileManager.default.removeItem(atPath: self.imagePath(fileName: fileName))
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
        
        opQueue.async { [weak self] in
            guard let `self` = self else {
                return
            }
            
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
    
    func fetch(key: String) -> UIImage? {
        let fileName = key.md5
        if let img = self.memCache.object(forKey: fileName as NSString) {
            return img
        }
        
        let imgPath = URL(fileURLWithPath: self.imagePath(fileName: fileName))
        do {
            let data = try Data(contentsOf: imgPath)
            if let img = UIImage(data: data) {
                self.memCache.setObject(img, forKey: fileName as NSString)
                return img
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    func fetch(key: String, completion:((UIImage?) -> ())? = nil) {
        opQueue.async { [weak self] in
            let img = self?.fetch(key: key)
            DispatchQueue.main.async {
                completion?(img)
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
        return cachePath.appendingPathComponent("prism_images").path
    }
}
