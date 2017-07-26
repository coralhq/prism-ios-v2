//
//  HeaderView.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 7/20/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

class HeaderView: UIView {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var container: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.layer.cornerRadius = imageView.frame.width/2
        imageView.layer.masksToBounds = true
    }
    
    func configure(settings: Settings) {
        titleLabel.textColor = settings.theme.strokeColor
        subtitleLabel.textColor = settings.theme.strokeColor
        
        titleLabel.text = settings.texts.titleExpanded
        subtitleLabel.text = settings.texts.subtitle
        
        container.removeArrangedSubview(imageView)
        if settings.persona.enabled {
            container.insertArrangedSubview(imageView, at: 0)
            imageView.downloadedFrom(url: settings.persona.imageURL)
        }
    }
}
