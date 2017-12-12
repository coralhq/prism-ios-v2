//
//  LinedTextField.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/8/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

class LinedTextField: UITextField {
    var isRequired: Bool = true
    
    let floatingLabelHeight: CGFloat = 15
    let bottomLineHeight: CGFloat = 1
    let warningLabelHeight: CGFloat = 15
    
    var bottomLineView = UIView()
    var floatingLabel = UILabel()
    var warningLabel = UILabel()
    
    @IBInspectable var placeholderColor: UIColor?  {
        didSet {
            setNeedsLayout()
            
            guard let placeholder = placeholder,
                let placeholderColor = placeholderColor else { return }
            
            attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [NSForegroundColorAttributeName: placeholderColor]
            )
        }
    }
    @IBInspectable var warningColor: UIColor?  {
        didSet { setNeedsLayout() }
    }
    @IBInspectable var selectedColor: UIColor?  {
        didSet { setNeedsLayout() }
    }
    @IBInspectable var warning: String? {
        didSet { setNeedsLayout() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    override public
    func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }
    
    func commonInit() {
        bottomLineView.backgroundColor = placeholderColor
        
        warningLabel.font = UIFont.systemFont(ofSize: 12)
        warningLabel.textColor = warningColor
        
        floatingLabel.font = UIFont.systemFont(ofSize: 12)
        floatingLabel.textColor = placeholderColor
        
        addSubview(bottomLineView)
        addSubview(warningLabel)
        addSubview(floatingLabel)
    }
    
    override public var textAlignment: NSTextAlignment {
        didSet {
            setNeedsLayout()
        }
    }
    
    override public var placeholder: String? {
        didSet {
            setNeedsLayout()
        }
    }
    
    override public var attributedPlaceholder: NSAttributedString? {
        didSet {
            setNeedsLayout()
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if let text = text,
            text.count > 0 {
            floatingLabel.isHidden = false
        } else {
            floatingLabel.isHidden = true
        }
        
        if let warning = warning,
            warning.count > 0 {
            bottomLineView.backgroundColor = warningLabel.textColor
            floatingLabel.textColor = isFirstResponder ? selectedColor : placeholderColor
        } else {
            if isFirstResponder {
                bottomLineView.backgroundColor = selectedColor
                floatingLabel.textColor = selectedColor
            } else {
                bottomLineView.backgroundColor = placeholderColor
                floatingLabel.textColor = placeholderColor
            }
        }
        
        floatingLabel.text = placeholder
        warningLabel.text = warning
        
        warningLabel.frame = warningLabelRect()
        floatingLabel.frame = floatingLabelRect()
        bottomLineView.frame = bottomLineRect()
    }
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return insetRect(forBounds: rect).integral
    }
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return insetRect(forBounds: rect).integral
    }
    
    func insetRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 0,
                      y: floatingLabelHeight,
                      width: bounds.width,
                      height: bounds.height - (floatingLabelHeight + warningLabelHeight))
    }
    
    func bottomLineRect() -> CGRect {
        return CGRect(x: 0, y: insetRect(forBounds: bounds).maxY, width: bounds.width, height: bottomLineHeight)
    }
    
    func warningLabelRect() -> CGRect {
        return CGRect(x: 0, y: bottomLineRect().maxY, width: bounds.width, height: warningLabelHeight)
    }
    
    func floatingLabelRect() -> CGRect {
        return CGRect(x: 0, y: 0, width: bounds.width, height: floatingLabelHeight)
    }
}
