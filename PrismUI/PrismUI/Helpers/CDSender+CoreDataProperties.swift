//
//  CDSender+CoreDataProperties.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 8/4/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import CoreData


extension CDSender {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDSender> {
        return NSFetchRequest<CDSender>(entityName: "CDSender")
    }

    @NSManaged public var appName: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var role: String?
    @NSManaged public var message: CDMessage?

}
