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
    @IBOutlet var optionsLabel: UILabel!
    @IBOutlet var notesLabel: UILabel!
    @IBOutlet var discountLabel: UILabel!
    @IBOutlet var qtyLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var container: UIStackView!
    
    var viewModel: ContentCartProductViewModel? {
        didSet {
            guard let vm = viewModel else {
                return
            }
            nameLabel.text = vm.name
            optionsLabel.text = vm.options
            notesLabel.text = vm.notes
            
            if let _ = vm.discount {
                priceLabel.text = vm.discount
                discountLabel.strikeTroughLined(with: vm.price)
            } else {
                priceLabel.text = vm.price
                discountLabel.text = nil
            }
            
            qtyLabel.text = vm.quantity
            
            container.removeArrangedSubview(imageView)
            if let url = vm.imageURL {
                container.insertArrangedSubview(imageView, at: 0)
                imageView.downloadedFrom(url: url, defaultImage: UIImage.image(with: "icPlaceholderS"))
            }
        }
    }
}
