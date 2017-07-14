//
//  CDBrokerMetaData+CoreDataClass.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/23/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import CoreData
import PrismCore

protocol CDManagedMappable {
    init(with context: NSManagedObjectContext, dictionary: [String: Any])
    func dictionaryValue() -> [String: Any]?
}

public class CDBrokerMetaData: NSManagedObject, CDManagedMappable {
    let df = Vendor.shared.dateFormatter
    
    required public init(with context: NSManagedObjectContext, dictionary: [String : Any]) {
        let entityDesc = NSEntityDescription.entity(forEntityName: CDBrokerMetaData.className(), in: context)!
        super.init(entity: entityDesc, insertInto: context)
        
        let timestamp = dictionary["timestamp"] as! String
        self.timestamp =  timestamp.ISO8601()
    }
    
    func dictionaryValue() -> [String : Any]? {
        guard let timestamp = timestamp else {
            return nil
        }
        return ["timestamp": timestamp.ISO8601()]
    }
}
