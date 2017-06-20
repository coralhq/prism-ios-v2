//
//  Utils.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/9/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation

class Utils {
    
    static func removeArchive(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func archive(object: Any, key: String) {
        let data = NSKeyedArchiver.archivedData(withRootObject: object)
        UserDefaults.standard.set(data, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func unarchive(key: String) -> Any? {
        guard let data = UserDefaults.standard.value(forKey: key) as? Data else { return nil }
        return NSKeyedUnarchiver.unarchiveObject(with: data)
    }
}

extension NSObject {
    static var name: String {
        get {
            return String(describing: self)
        }
    }
}

extension Bundle {
    static var prism: Bundle {
        return Bundle(for: ConnectViewController.classForCoder())
    }
}

extension UITableViewCell {
    static var NIB: UINib {
        return UINib.init(nibName: self.name, bundle: Bundle.prism)
    }
}
