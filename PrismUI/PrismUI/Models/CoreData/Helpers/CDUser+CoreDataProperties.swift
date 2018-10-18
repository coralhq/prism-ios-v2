//
//  CDUser+CoreDataProperties.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 7/19/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import CoreData


extension CDUser {

    @nonobjc class func fetchRequest() -> NSFetchRequest<CDUser> {
        return NSFetchRequest<CDUser>(entityName: "CDUser")
    }

    @NSManaged var id: String?
    @NSManaged var name: String?
        @NSManaged var channelInfo: CDMessage?
    @NSManaged var visitor: CDMessage?

}
