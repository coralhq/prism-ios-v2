//
//  CDUser+CoreDataClass.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/23/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import CoreData
import PrismCore

public class CDUser: NSManagedObject {
    convenience init(context: NSManagedObjectContext, user: MessageUser?) {
        let entityDesc = NSEntityDescription.entity(forEntityName: CDUser.className(), in: context)!
        self.init(entity: entityDesc, insertInto: context)

        id = user?.id
        name = user?.name
    }
}
