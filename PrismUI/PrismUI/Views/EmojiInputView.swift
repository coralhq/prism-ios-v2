//
//  EmojiInputView.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/13/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

struct EmojiCategory {
    var icon: UIImage?
    var name: String
}

extension UIImage {
    convenience init?(imageNamed: String) {
        self.init(named: imageNamed, in: Bundle.prism, compatibleWith: nil)
    }
}

class EmojiInputView: UIView {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var emojiOptionView: OptionView!
    
    static func viewFromNib(textView: UITextView?) -> EmojiInputView {
        let inputView = self.viewFromNib() as! EmojiInputView
        inputView.inputTextView = textView
        return inputView
    }
    
    weak var inputTextView: UITextView? {
        didSet {
            inputTextView?.inputView = self
            inputTextView?.reloadInputViews()
        }
    }
    
    var emojis: [String: [String]] = [:]
    var categories: [EmojiCategory] = []
    var selectedCategory: EmojiCategory? {
        didSet {
            collectionView.reloadData()
        }
    }
    var recentEmojis: [String] = [] {
        didSet {
            UserDefaults.standard.set(recentEmojis, forKey: "prism_recent_emoji")
        }
    }
    var selectedEmojis: [String] {
        get {
            guard let selectedCategory = selectedCategory else { return [] }
            
            if selectedCategory.name == "Recent" {
                return recentEmojis
            } else {
                guard let emojis = emojis[selectedCategory.name] else { return [] }
                return emojis
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let savedRecentEmojis = UserDefaults.standard.value(forKey: "prism_recent_emoji") as? [String] {
            recentEmojis = savedRecentEmojis
        }
        
        categories = [EmojiCategory(icon: UIImage(imageNamed: "icRecent"), name: "Recent"),
                      EmojiCategory(icon: UIImage(imageNamed: "icSmileysPeople"), name: "People"),
                      EmojiCategory(icon: UIImage(imageNamed: "icObjects"), name: "Objects"),
                      EmojiCategory(icon: UIImage(imageNamed: "icAnimalsNature"), name: "Nature"),
                      EmojiCategory(icon: UIImage(imageNamed: "icTravelPlaces"), name: "Places"),
                      EmojiCategory(icon: UIImage(imageNamed: "icSymbols"), name: "Symbols")]
        
        var buttons: [OptionButton] = []
        for (index, value) in categories.enumerated() {
            let button = OptionButton(image: value.icon, selectedColor: #colorLiteral(red: 0.8690459132, green: 0.3152537942, blue: 0.4390725493, alpha: 1))
            button.tag = index
            buttons.append(button)
        }
        emojiOptionView.buttons = buttons
        
        guard let path = Bundle.prism.path(forResource: "EmojisList", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) as? [String: [String]] else { return }
        emojis = dict
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(EmojiCell.classForCoder(), forCellWithReuseIdentifier: EmojiCell.className())
    }
}

extension EmojiInputView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedEmojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.className(), for: indexPath) as! EmojiCell
        cell.emojiLabel.text = selectedEmojis[indexPath.row]
        return cell
    }
}

extension EmojiInputView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let emoji = selectedEmojis[indexPath.row]
        
        inputTextView?.insertText(emoji)
        
        if !recentEmojis.contains(where: { $0 == emoji }) {
            recentEmojis.insert(emoji, at: 0)
            if recentEmojis.count > 50 {
                recentEmojis.removeLast()
            }
        }
    }
}

extension EmojiInputView {
    @IBAction func backspacePressed(sender: UIButton) {
        inputTextView?.deleteBackward()
    }
    
    @IBAction func optionValueChanged(sender: OptionView) {
        guard let selectedOption = sender.selectedButton else { return }
        selectedCategory = categories[selectedOption.tag]
    }
}

class EmojiCell: UICollectionViewCell {
    var emojiLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        emojiLabel.font = UIFont.systemFont(ofSize: 20)
        emojiLabel.addTo(view: self, margin: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
