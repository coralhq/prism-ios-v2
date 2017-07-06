//
//  CDBrokerMetaData+CoreDataProperties.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/23/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import CoreData


extension CDBrokerMetaData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDBrokerMetaData> {
        return NSFetchRequest<CDBrokerMetaData>(entityName: "CDBrokerMetaData")
    }

    @NSManaged public var timestamp: Date?
    @NSManaged public var message: CDMessage?

}
