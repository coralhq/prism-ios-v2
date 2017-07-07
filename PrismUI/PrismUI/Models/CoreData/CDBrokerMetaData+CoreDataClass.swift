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

public class CDBrokerMetaData: NSManagedObject {
    convenience init(context: NSManagedObjectContext, brokerMetaData: BrokerMetaData) {
        let entityDesc = NSEntityDescription.entity(forEntityName: CDBrokerMetaData.className(), in: context)!
        self.init(entity: entityDesc, insertInto: context)
        
        timestamp = brokerMetaData.timestamp
    }
}
