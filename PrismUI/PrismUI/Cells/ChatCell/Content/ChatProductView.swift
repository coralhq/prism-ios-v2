//
//  ChatProductView.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/19/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

class ChatProductView: ChatContentView {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var optionsLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var discountLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var productListHeight: NSLayoutConstraint!
    @IBOutlet var productPageControlHeight: NSLayoutConstraint!
    
    var imageURLs: [URL] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        pageControl.pageIndicatorTintColor = Settings.shared.theme.buttonColor.withAlphaComponent(0.5)
        pageControl.currentPageIndicatorTintColor = Settings.shared.theme.buttonColor
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: ContentProductCell.className(), bundle: Bundle.prism), forCellWithReuseIdentifier: ContentProductCell.className())
    }
    
    override func updateView(with viewModel: ChatViewModel) {
        guard let contentVM = viewModel.contentViewModel as? ContentProductViewModel else {
            return
        }
        nameLabel.text = contentVM.name
        descriptionLabel.text = contentVM.description
        optionsLabel.text = contentVM.options
        
        if let _ = contentVM.discount {
            priceLabel.text = contentVM.discount
            discountLabel.strikeTroughLined(with: contentVM.price)
        } else {
            priceLabel.text = contentVM.price
            discountLabel.strikeTroughLined(with: nil)
        }
        
        imageURLs = contentVM.imageURLs
        collectionView.reloadData()
        
        if imageURLs.count > 0 {
            productListHeight.constant = 190
            productPageControlHeight.constant = 20
        } else {
            productListHeight.constant = 0
            productPageControlHeight.constant = 0
        }
        
        calculateContentWidth(label: descriptionLabel, supportLeft: false)
    }
}

extension ChatProductView: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        pageControl.currentPage = Int(scrollView.contentOffset.x / pageWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let rootVC = UIViewController.root else {
            return
        }
        let pictures = imageURLs.map { CollieGalleryPicture(url: $0.absoluteString) }
        let viewer = CollieGallery(pictures: pictures, options: nil, theme: nil)
        viewer.presentInViewController(rootVC)
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
        cell.imageView.downloadedFrom(link: imageURLs[indexPath.row], contentMode: UIImage.image(with: "icPlaceholderS"))
        return cell
    }
}
