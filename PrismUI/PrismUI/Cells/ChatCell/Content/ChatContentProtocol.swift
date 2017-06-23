//
//  ChatContentProtocol.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/19/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit

protocol ChatContentProtocol {
    func infoPosition() -> InfoViewPosition
    func addTo(view: UIView?) -> Void
}
