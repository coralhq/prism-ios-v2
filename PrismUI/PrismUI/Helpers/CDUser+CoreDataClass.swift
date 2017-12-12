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

class CDUser: NSManagedObject, CDManagedMappable {
    required public init(with context: NSManagedObjectContext, dictionary: [String : Any]) {
        let entityDesc = NSEntityDescription.entity(forEntityName: CDUser.className(), in: context)!
        super.init(entity: entityDesc, insertInto: context)
        
        id = dictionary["id"] as? String
        name = dictionary["name"] as? String
    }
    
    public override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    func dictionaryValue() -> [String : Any]? {
        guard let id = id,
            let name = name else {
                return nil
        }
        return ["id": id, "name": name]
    }
}
