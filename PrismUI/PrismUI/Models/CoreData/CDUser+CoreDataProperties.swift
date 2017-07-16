//
//  CDUser+CoreDataProperties.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 7/14/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import CoreData


extension CDUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDUser> {
        return NSFetchRequest<CDUser>(entityName: "CDUser")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var channelInfo: CDMessage?
    @NSManaged public var visitor: CDMessage?

}
