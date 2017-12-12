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

    @nonobjc class func fetchRequest() -> NSFetchRequest<CDSender> {
        return NSFetchRequest<CDSender>(entityName: "CDSender")
    }

    @NSManaged var appName: String?
    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var role: String?
    @NSManaged var message: CDMessage?

}
