//
//  EmptyChatView.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 8/8/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

class EmptyChatView: UIView {
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        transform = CGAffineTransform(scaleX: 1, y: -1)
        
        backgroundColor = Settings.shared.theme.headerColor.withAlphaComponent(0.05)
        
        titleLabel.text = Settings.shared.connectForm.message
    }
}
