//
//  PrismCoreDelegate.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/23/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

public protocol PrismCoreDelegate: class {
    func didReceive(message data: Data, in topic: String)
}
