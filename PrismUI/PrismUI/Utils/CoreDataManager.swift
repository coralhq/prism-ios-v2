//
//  CoreDataManager.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 7/11/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import CoreData
import PrismCore

enum MessageStatus: Int16 {
    case sent = 1
    case pending = 2
}

class CoreDataManager {
    var context: NSManagedObjectContext
    
    init?() {
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        
        guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
            let modelURL = Bundle.prism.url(forResource: "Chat", withExtension: "momd"),
            let model = NSManagedObjectModel(contentsOf: modelURL)
            else {
                return nil
        }
        
        let dbURL = docURL.appendingPathComponent("prism_sdk.sqlite")
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: dbURL, options: nil)
        } catch {
            return nil
        }
        
        context.persistentStoreCoordinator = coordinator
    }
    
    func createChildContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = self.context
        return context
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            print("error \(error)")
        }
    }
    
    func saveMessage(message: Message, status: MessageStatus) {
        var cdmsg = messageWithIdentifier(identifier: message.id)
        if cdmsg == nil {
            cdmsg = CDMessage(with: context)
        }
        
        if let cdmsg = cdmsg {
            cdmsg.setMessage(message: message)
            cdmsg.status = status.rawValue
            save()
        }
    }
    
    func messageWithIdentifier(identifier: String) -> CDMessage? {
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: CDMessage.className())
        req.predicate = NSPredicate(format: "id == %@", identifier)
        do {
            return try context.fetch(req).first as? CDMessage
        } catch {
            print("error \(error)")
            return nil
        }
    }
}
