//
//  ChatCartView.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/19/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

class ChatCartView: UIView {
    @IBOutlet var productContainer: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        for _ in 0..<3 {
            guard let productView = ProductCartView.viewFromNib() else { continue }
            productContainer.addArrangedSubview(productView)
        }
    }
}

extension ChatCartView: ChatContentProtocol {
    func addTo(view: UIView?) {
        addTo(view: view, margin: 0)
    }
    
    func infoPosition() -> InfoViewPosition {
        return .Bottom
    }
}
