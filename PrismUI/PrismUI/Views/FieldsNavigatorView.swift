//
//  FieldsNavigatorView.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 8/21/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

class FieldsNavigatorView: UIView {
    @IBOutlet var doneButton: SmallButton!
    @IBOutlet var nextButton: SmallButton!
    @IBOutlet var prevButton: SmallButton!
    
    var selectedIndex: Int = 0
    
    var textFields: [UITextField] = [] {
        didSet {
            for field in textFields {
                field.inputAccessoryView = self
                field.addTarget(self, action: #selector(editingBegin(sender:)), for: .editingDidBegin)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nextButton.color = Settings.shared.theme.buttonColor
        nextButton.disabledColor = Settings.shared.theme.buttonColor.withAlphaComponent(0.5)
        prevButton.color = Settings.shared.theme.buttonColor
        prevButton.disabledColor = Settings.shared.theme.buttonColor.withAlphaComponent(0.5)
        
        doneButton.setTitleColor(Settings.shared.theme.buttonColor, for: .normal)
    }
    
    @objc func editingBegin(sender: UITextField) {
        if let index = textFields.index(of: sender) {
            selectFieldsAt(index: index)
        }
    }
    
    func selectFieldsAt(index: Int) {
        selectedIndex = index
        if index == textFields.count {
            selectedIndex = textFields.count - 1
        }
        
        if index < 0 {
            selectedIndex = 0
        }
        
        nextButton.isEnabled = selectedIndex != textFields.count - 1
        prevButton.isEnabled = selectedIndex != 0
        
        let tf = textFields[selectedIndex]
        tf.becomeFirstResponder()
    }
    
    @IBAction func donePressed(sender: UIButton) {
        textFields[selectedIndex].resignFirstResponder()
    }
    
    @IBAction func prevPressed(sender: UIButton) {
        selectFieldsAt(index: selectedIndex - 1)
    }
    
    @IBAction func nextPressed(sender: UIButton) {
        selectFieldsAt(index: selectedIndex + 1)
    }
}
