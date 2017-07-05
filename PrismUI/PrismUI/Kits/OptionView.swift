//
//  OptionView.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/13/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

class OptionButton: SmallButton {
    @IBInspectable var lineColor: UIColor?
    var bottomLine: UIView?
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                bottomLine?.backgroundColor = lineColor
                imageView?.alpha = 1
            } else {
                bottomLine?.backgroundColor = UIColor.clear
                imageView?.alpha = 0.7
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(image: UIImage?, selectedColor: UIColor?) {
        self.init(frame: .zero)

        self.lineColor = color
        
        setImage(image, for: .normal)
        setImage(image, for: .highlighted)
        
        bottomLine = UIView()
        guard let bottomLine = bottomLine else { return }
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomLine)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[line]-0-|", options: .init(rawValue: 0), metrics: nil, views: ["line": bottomLine]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[line(2)]-0-|", options: .init(rawValue: 0), metrics: nil, views: ["line": bottomLine]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class OptionView: UIControl {

    @IBOutlet var buttons: [OptionButton]? {
        didSet {
            guard let buttons = buttons else { return }
            
            for view in containerView.arrangedSubviews {
                view.removeFromSuperview()
            }
            
            for button in buttons {
                containerView.addArrangedSubview(button)
            }
        }
    }
    var selectedButton: OptionButton?
    var containerView: UIStackView = UIStackView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.axis = .horizontal
        containerView.spacing = 0
        containerView.distribution = .fillEqually
    
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[container]-0-|", options: .init(rawValue: 0), metrics: nil, views: ["container": containerView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[container]-0-|", options: .init(rawValue: 0), metrics: nil, views: ["container": containerView]))
        
        guard let buttons = buttons else { return }
        
        for button in buttons {
            button.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        }
        
        if buttons.count > 0 {
            selectOption(atIndex: 0)
        }
    }
    
    func selectOption(atIndex index: Int) {
        guard let button = buttons?[index] else { return }
        buttonPressed(sender: button)
    }
    
    func buttonPressed(sender: OptionButton) {
        guard let buttons = buttons else { return }
        
        for button in buttons {
            button.isSelected = false
        }
        sender.isSelected = true
        
        selectedButton = sender
        
        sendActions(for: .valueChanged)
    }
}
