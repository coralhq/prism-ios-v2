//
//  DemoMenuCollectionViewCell.swift
//  DemoPrismCore
//
//  Created by fanni suyuti on 6/9/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

class DemoMenuCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var merkLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(image: UIImage, title: String, description: String, price: String) {
        
        descriptionLabel.text = description
        merkLabel.text = title
        priceLabel.text = price
        
        self.image.image = image
    }
}
