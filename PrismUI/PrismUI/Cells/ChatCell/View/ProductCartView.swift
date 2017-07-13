//
//  ProductCartView.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/19/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

class ProductCartView: UIView {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var discountLabel: UILabel!
    @IBOutlet var qtyLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    var viewModel: ContentCartProductViewModel? {
        didSet {
            guard let vm = viewModel else { return }
            nameLabel.text = vm.name
            
            if let _ = vm.discount {
                priceLabel.text = vm.discount
                discountLabel.strikeTroughLined(with: vm.price)
            } else {
                priceLabel.text = vm.price
                discountLabel.text = nil
            }
            
            qtyLabel.text = vm.quantity
            
            guard let imageURL = vm.imageURL else { return }
            imageView.downloadedFrom(url: imageURL)
        }
    }
}
