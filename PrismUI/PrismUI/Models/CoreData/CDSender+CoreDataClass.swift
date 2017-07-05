//
//  CDSender+CoreDataClass.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 6/23/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import CoreData
import PrismCore

public class CDSender: NSManagedObject {

    convenience init(context: NSManagedObjectContext, sender: MessageSender) {
        let entityDesc = NSEntityDescription.entity(forEntityName: CDSender.className(), in: context)!
        self.init(entity: entityDesc, insertInto: context)
        
        id = sender.id
        name = sender.name
        role = sender.role
        userAgent = sender.userAgent
    }
}
