//
//  StickerInputView.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/22/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import PrismCore

protocol StickerInputViewDelegate: class {
    func stickerInputView(view: StickerInputView, didSend sticker: StickerViewModel)
}

class StickerInputView: UIView {
    @IBOutlet var contentStickerView: UICollectionView!
    @IBOutlet var sectionStickerView: UICollectionView!
    
    weak var delegate: StickerInputViewDelegate?
    
    var packs: [StickerPackViewModel] = [] {
        didSet {
            sectionStickerView.reloadData()
            
            guard let pack = packs.first else { return }
            selectedPack = pack
            sectionStickerView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .init(rawValue: 0))
        }
    }
    
    var selectedPack: StickerPackViewModel? {
        didSet {
            contentStickerView.reloadData()
        }
    }
    
    static func viewFromNib(accessToken: String?) -> StickerInputView? {
        let view: StickerInputView? = StickerInputView.viewFromNib()
        view?.getStickers(token: accessToken)
        return view
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentStickerView.dataSource = self
        sectionStickerView.dataSource = self
        contentStickerView.delegate = self
        sectionStickerView.delegate = self
        
        contentStickerView.register(StickerContentCell.classForCoder(), forCellWithReuseIdentifier: StickerContentCell.className())
        sectionStickerView.register(StickerSectionCell.classForCoder(), forCellWithReuseIdentifier: StickerSectionCell.className())
    }
    
    func stickers(with pack: StickerPackViewModel?) -> [StickerViewModel] {
        guard let selectedPack = pack else { return [] }
        
        let packs = self.packs.filter({ (pack) -> Bool in
            return pack.name == selectedPack.name
        })
        
        if let stickers = packs.first?.stickers {
            return stickers
        } else {
            return []
        }
    }
    
    private func getStickers(token: String?) {
        if let packs: [StickerPackViewModel] = Utils.unarchive(key: "prism_sticker_packs") {
            self.packs = packs
        } else {
            guard let token = token else { return }
            StickerPackViewModel.getStickers(accessToken: token, completion: { [weak self] (packs) in
                guard let packs = packs else {
                    return
                }
                self?.packs = packs
                Utils.archive(object: packs, key: "prism_sticker_packs")
            })
        }
    }
}

extension StickerInputView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == sectionStickerView {
            return packs.count
        }        
        return stickers(with: selectedPack).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == sectionStickerView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StickerSectionCell.className(), for: indexPath) as! StickerSectionCell
            cell.stickerImageView.downloadedFrom(url: packs[indexPath.row].imageURL, contentMode: .scaleAspectFill)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StickerContentCell.className(), for: indexPath) as! StickerContentCell
        let sticker = stickers(with: selectedPack)[indexPath.row]
        cell.stickerImageView.downloadedFrom(url: sticker.imageURL, contentMode: .scaleAspectFill)
        return cell
    }
}

extension StickerInputView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == sectionStickerView {
            selectedPack = packs[indexPath.row]
        } else {
            delegate?.stickerInputView(view: self, didSend: stickers(with: selectedPack)[indexPath.row])
        }
    }
}

class StickerSectionCell: UICollectionViewCell {
    var stickerImageView: UIImageView = UIImageView()
    var bottomLine: UIView = UIView()
    var selectedLineColor = UIColor.red
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stickerImageView.addTo(view: self, margin: 6)
        
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomLine)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[line]-0-|", options: .init(rawValue: 0), metrics: nil, views: ["line": bottomLine]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[line(2)]-0-|", options: .init(rawValue: 0), metrics: nil, views: ["line": bottomLine]))
    }
    
    override var isSelected: Bool {
        didSet {
            bottomLine.backgroundColor = isSelected ? selectedLineColor : UIColor.clear
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class StickerContentCell: UICollectionViewCell {
    var stickerImageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stickerImageView.translatesAutoresizingMaskIntoConstraints = false
        stickerImageView.addTo(view: self, margin: 4)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
