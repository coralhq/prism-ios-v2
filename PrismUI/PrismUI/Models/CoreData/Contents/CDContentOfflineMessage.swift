//
//  CDContentOfflineMessage.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/23/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import PrismCore

class CDContentOfflineMessage: ValueTransformer, NSCoding {
    var name: String?
    var email: String?
    var phone: String?
    var text: String?
    
    init(offlineMessage: ContentOfflineMessage) {    
        name = offlineMessage.name
        email = offlineMessage.email
        phone = offlineMessage.phone
        text = offlineMessage.text
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(text, forKey: "text")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
        phone = aDecoder.decodeObject(forKey: "phone") as? String
        text = aDecoder.decodeObject(forKey: "text") as? String
    }
}
