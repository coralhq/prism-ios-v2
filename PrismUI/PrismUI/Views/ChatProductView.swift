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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: ContentProductCell.name, bundle: Bundle.prism), forCellWithReuseIdentifier: ContentProductCell.name)
    }
}

extension ChatProductView: ChatContentProtocol {
    func addTo(view: UIView?) {
        addTo(view: view, margin: 0)
    }
    
    func infoPosition() -> InfoViewPosition {
        return .Bottom
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
        let count = 4
        pageControl.numberOfPages = count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentProductCell.name, for: indexPath)
        return cell
    }
}
