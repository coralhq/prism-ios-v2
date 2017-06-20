//
//  OptionButtons.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/13/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

class OptionButtons: UIControl {

    @IBOutlet var buttons: [UIButton]!
    
    var selectedButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        for button in buttons {
            button.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        }
        
        if buttons.count > 0 {
            guard let firstButton = buttons.first else { return }
            buttonPressed(sender: firstButton)
        }
    }
    
    func buttonPressed(sender: UIButton) {
        for button in buttons {
            button.isSelected = false
        }
        sender.isSelected = true
        
        selectedButton = sender
        
        sendActions(for: .valueChanged)
    }
}
