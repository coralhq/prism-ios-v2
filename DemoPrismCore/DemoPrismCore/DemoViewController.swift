//
//  DemoViewController.swift
//  DemoPrismCore
//
//  Created by fanni suyuti on 6/13/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import PrismUI

private let reuseIdentifier = "Cell"

class DemoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var chatButton: UIButton!
    
    let sectionInsets = UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0)
    var viewModel = DemoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "main demo"
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nib = UINib(nibName: "DemoMenuCollectionViewCell", bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.backgroundColor = UIColor.lightGray
        
        chatButton.layer.cornerRadius = 15
        chatButton.backgroundColor = .white
    }
    
    @IBAction func chatAction(_ sender: Any) {
        viewModel.presentChatWidget(on: self)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DemoMenuCollectionViewCell
        
        cell.configure(image: viewModel.products[indexPath.row].image, title: viewModel.products[indexPath.row].merk, description: viewModel.products[indexPath.row].description, price: viewModel.products[indexPath.row].price)
        
        return cell
    }
}

extension DemoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (3)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / 2
        
        return CGSize(width: widthPerItem, height: 270)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

class DemoViewModel {
    var products: [ProductDemo] = []
    var setting: [String: Any]?
    
    init() {
        let product = ProductDemo(image: UIImage(named: "persebaya")!, merk: "ADIDAS", description: "KW Super", price: "Rp. 750.000,00")
        for _ in 0..<10 {
            products.append(product)
        }
    }
    
    func presentChatWidget(on vc: UIViewController) {
        PrismUI.shared.present(on: vc)
    }
}

struct ProductDemo {
    let image: UIImage
    let merk: String
    let description: String
    let price: String
}

