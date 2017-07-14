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
    fileprivate var privateContext: NSManagedObjectContext
    var mainContext: NSManagedObjectContext
    
    init?() {
        mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = mainContext
        
        guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
            let modelURL = Bundle.prism.url(forResource: "Chat", withExtension: "momd"),
            let model = NSManagedObjectModel(contentsOf: modelURL)
            else {
                return
        }
        
        do {
            let storeURL = docURL.appendingPathComponent("prism_sdk.sqlite")
            let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
            mainContext.persistentStoreCoordinator = psc
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch {
            print("Error: \(error)")
        }
    }
    
    func save() {
        guard privateContext.hasChanges else {
            return
        }
        
        privateContext.perform {
            do {
                try self.privateContext.save()
                
                self.mainContext.perform({
                    do {
                        try self.mainContext.save()
                    } catch {
                        print("Error \(error)")
                    }
                })
            } catch {
                print("Error \(error)")
            }
        }
    }
    
    @discardableResult
    func buildMessage(message: Message, status: MessageStatus) -> CDMessage {
        var cdmsg = messageWithIdentifier(identifier: message.id)
        if cdmsg == nil {
            cdmsg = CDMessage(with: privateContext, dictionary: message.dictionaryValue())
        } else {
            cdmsg?.updateMessage(with: message.dictionaryValue())
        }
        cdmsg?.status = status.rawValue
        return cdmsg!
    }
    
    func messageWithIdentifier(identifier: String) -> CDMessage? {
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: CDMessage.className())
        req.predicate = NSPredicate(format: "id == %@", identifier)
        do {
            return try privateContext.fetch(req).first as? CDMessage
        } catch {
            print("error \(error)")
            return nil
        }
    }
}
