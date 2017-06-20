//
//  EmojiInputView.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/13/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

class EmojiInputView: UIView {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var emojis: [[String]] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let path = Bundle.prism.path(forResource: "EmojisList", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) as? [String: Any] else { return }
        
        for key in dict.keys {
            emojis.append(dict[key] as! [String])
        }
    }
}
