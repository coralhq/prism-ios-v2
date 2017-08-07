//
//  CloseChatTableViewCell.swift
//  PrismUI
//
//  Created by fanni suyuti on 8/3/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import PrismCore

protocol CloseChatTableViewCellDelegate: class {
    func reconnectTapped(sender: UIButton)
}

class CloseChatTableViewCell: UITableViewCell {
    
    weak var delegate: CloseChatTableViewCellDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var reconnectButton: UIButton!
    
    static var reuseIdentifier = "CloseChatTableViewCellIdentifier"
    let viewModel = AuthViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.setAffineTransform(CGAffineTransform.init(scaleX: 1, y: -1))
        
        reconnectButton.setTitleColor(Settings.shared.theme.buttonColor, for: .normal)
        reconnectButton.layer.cornerRadius = 3
        reconnectButton.layer.borderWidth = 1
        reconnectButton.layer.borderColor = Settings.shared.theme.buttonColor.cgColor
    }
    
    func configure(viewModel: ContentCloseChatViewModel) {
        titleLabel.text = viewModel.text
    }
    
    @IBAction func reconnectButtonAction(_ sender: UIButton) {
        delegate?.reconnectTapped(sender: sender)
    }
}
