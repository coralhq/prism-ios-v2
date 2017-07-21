//
//  UIView.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/18/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation

extension UIView {
    func constraint(with attribute: NSLayoutAttribute) -> NSLayoutConstraint? {
        let filteredArray = constraints.filter { (constraint) -> Bool in
            return constraint.firstAttribute == attribute
        }
        return filteredArray.first
    }
    
    static func viewFromNib<T>() -> T? {
        return Bundle.prism.loadNibNamed(String(describing: self), owner: self, options: nil)?.first as? T
    }
    
    func addTo(view: UIView?, margin: Double) {
        translatesAutoresizingMaskIntoConstraints = false
        view?.addSubview(self)
        view?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-margin-[view]-margin-|", options: .init(rawValue: 0), metrics: ["margin": margin], views: ["view": self]))
        view?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-margin-[view]-margin-|", options: .init(rawValue: 0), metrics: ["margin": margin], views: ["view": self]))
    }
}
