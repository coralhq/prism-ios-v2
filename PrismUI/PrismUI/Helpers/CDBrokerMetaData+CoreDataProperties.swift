//
//  CDBrokerMetaData+CoreDataProperties.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 7/19/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import CoreData


extension CDBrokerMetaData {

    @nonobjc class func fetchRequest() -> NSFetchRequest<CDBrokerMetaData> {
        return NSFetchRequest<CDBrokerMetaData>(entityName: "CDBrokerMetaData")
    }

    @NSManaged var timestamp: Date?
    @NSManaged var message: CDMessage?

}
