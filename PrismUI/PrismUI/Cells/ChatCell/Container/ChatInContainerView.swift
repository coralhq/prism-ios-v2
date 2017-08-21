//
//  ChatInContainerView.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/18/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

class ChatInContainerView: ChatContainerView {
    @IBOutlet var bubleView: ChatBubleView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        bubleView.strokeColor = Settings.shared.theme.buttonColor.withAlphaComponent(0.15)
    }
}
