//
//  String.swift
//  PrismCoreSDK
//
//  Created by fanni suyuti on 5/18/17.
//  Copyright © 2017 fanni suyuti. All rights reserved.
//

import Foundation

extension String {
    static var randomVisitorName: String {
        get {
            return "IOSVisitor-\(randomString(length: 10))"
        }
    }
    
    static var randomUserID: String {
        get {
            return "IOSUserID-\(randomString(length: 10))"
        }
    }
    
    static private func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}
