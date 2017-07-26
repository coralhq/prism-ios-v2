//
//  ChatCartView.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/19/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

class ChatCartView: ChatContentView {
    @IBOutlet var productContainer: UIStackView!
    @IBOutlet var totalPriceLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        descriptionLabel.text = "Biaya diatas belum termasuk ongkos kirim".localized()
    }
    
    override func updateView(with viewModel: ChatViewModel) {
        guard let vm = viewModel.contentViewModel as? ContentCartViewModel else {
            return
        }
        totalPriceLabel.text = vm.formattedPrice
        
        for view in productContainer.arrangedSubviews {
            productContainer.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        for itemVM in vm.itemViewModels {
            guard let view: ProductCartView = ProductCartView.viewFromNib() else { continue }
            view.viewModel = itemVM
            productContainer.addArrangedSubview(view)
        }
        
        calculateContentWidth(label: descriptionLabel)
    }
}
