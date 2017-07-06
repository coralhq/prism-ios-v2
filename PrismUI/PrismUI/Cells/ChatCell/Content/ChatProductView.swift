//
//  ChatProductView.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/19/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

class ChatProductView: UIView {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var discountLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    var imageURLs: [URL] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: ContentProductCell.className(), bundle: Bundle.prism), forCellWithReuseIdentifier: ContentProductCell.className())
    }
}

extension ChatProductView: ChatContentProtocol {
    func addTo(view: UIView?) {
        addTo(view: view, margin: 0)
    }
    
    func infoPosition() -> InfoViewPosition {
        return .Bottom
    }
    
    func updateView(with viewModel: ChatViewModel) {
        guard let contentVM = viewModel.contentViewModel as? ContentProductViewModel else { return }
        nameLabel.text = contentVM.name
        descriptionLabel.text = contentVM.description
        
        if let _ = contentVM.discount {
            priceLabel.text = contentVM.discount
            discountLabel.strikeTroughLined(with: contentVM.price)
        } else {
            priceLabel.text = contentVM.price
            discountLabel.strikeTroughLined(with: nil)
        }
        
        imageURLs = contentVM.imageURLs
        collectionView.reloadData()
    }
}

extension ChatProductView: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        pageControl.currentPage = Int(scrollView.contentOffset.x / pageWidth)
    }
}

extension ChatProductView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = imageURLs.count
        pageControl.numberOfPages = count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ContentProductCell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentProductCell.className(), for: indexPath) as! ContentProductCell
        cell.imageView.downloadedFrom(url: imageURLs[indexPath.row])
        return cell
    }
}
