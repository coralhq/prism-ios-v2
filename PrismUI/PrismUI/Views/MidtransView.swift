//
//  MidtransView.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/19/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

class MidtransView: UIView {
    @IBOutlet var payButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        payButton.layer.cornerRadius = 3
        payButton.layer.borderWidth = 1
        payButton.layer.borderColor = payButton.currentTitleColor.cgColor
    }

}