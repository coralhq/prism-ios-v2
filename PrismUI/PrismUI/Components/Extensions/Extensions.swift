//
//  Extensions.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 7/5/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.prism, value: "", comment: "")
    }
}

extension NSObject {
    static func className() -> String {
        return String(describing: self)
    }
}

extension Bundle {
    static var prism: Bundle {
        return Bundle(for: ConnectViewController.classForCoder())
    }
}

extension UITableViewCell {
    static var NIB: UINib {
        return UINib.init(nibName: self.className(), bundle: Bundle.prism)
    }
}

extension Array {
    mutating func moveElement(fromIndex: Int, toIndex: Int) {
        let element = remove(at: fromIndex)
        insert(element, at: toIndex)
    }
}

extension Array where Element : ChatViewModel {
    
    func containsChatViewModel(viewModel: ChatViewModel) -> Bool {
        return self.contains(where: { (vm) -> Bool in
            return vm.messageID == viewModel.messageID
        })
    }
    
    mutating func insert(viewModel: ChatViewModel, at index: Int) {
        if self.containsChatViewModel(viewModel: viewModel) == false {
            insert(viewModel as! Element, at: index)
        }
    }
    
    mutating func update(viewModel: ChatViewModel, at index: Int) {
        remove(at: index)
        insert(viewModel as! Element, at: index)
    }
}
