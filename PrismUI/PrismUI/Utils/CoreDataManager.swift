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
        mainContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
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
            privateContext.persistentStoreCoordinator = psc
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch {
            print("Error: \(error)")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(mocDidSave(note:)), name: .NSManagedObjectContextDidSave, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func save() {
        guard self.privateContext.hasChanges else {
            return
        }
        
        do {
            try self.privateContext.save()
        } catch {
            print("Error \(error)")
        }
    }
    
    @discardableResult
    func buildMessage(message: Message, status: MessageStatus) -> CDMessage {
        var cdmsg = fetchMessage(identifier: message.id)
        if cdmsg == nil {
            cdmsg = CDMessage(with: privateContext, dictionary: message.dictionaryValue())
        } else {
            cdmsg?.updateMessage(with: message.dictionaryValue())
        }
        cdmsg?.status = status.rawValue
        return cdmsg!
    }
    
    func saveMessages(messages: [Message]) {
        DispatchQueue(label: "save_queue").async {
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.persistentStoreCoordinator = self.mainContext.persistentStoreCoordinator
            
            for message in messages {
                var cdmessage = self.fetchMessage(identifier: message.id, context: context)
                if cdmessage == nil {
                    cdmessage = CDMessage(with: context, dictionary: message.dictionaryValue())
                    cdmessage?.status = MessageStatus.sent.rawValue
                }
            }
            
            do {
                guard context.hasChanges else {
                    return
                }
                try context.save()
            } catch {
                print("Save error \(error)")
            }
        }
    }
    
    func fetchMessage(identifier: String) -> CDMessage? {
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: CDMessage.className())
        req.predicate = NSPredicate(format: "id == %@", identifier)
        do {
            return try privateContext.fetch(req).first as? CDMessage
        } catch {
            print("error \(error)")
            return nil
        }
    }
    
    func fetchMessage(identifier: String, context: NSManagedObjectContext) -> CDMessage? {
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: CDMessage.className())
        req.predicate = NSPredicate(format: "id == %@", identifier)
        do {
            return try context.fetch(req).first as? CDMessage
        } catch {
            return nil
        }
    }
    
    func fetchPendingMessages(completion:(([CDMessage]) -> ())?) {
        DispatchQueue(label: "fetch_queue").async {
            let request = NSFetchRequest<CDMessage>(entityName: CDMessage.className())
            request.predicate = NSPredicate(format: "status == %i", MessageStatus.pending.rawValue)
            do {
                let messages = try self.privateContext.fetch(request)
                DispatchQueue.main.async {
                    completion?(messages)
                }
            } catch {
                print("Error \(error)")
            }
        }
    }
    
    func fetchLatestMessage(completion:((CDMessage) -> ())?) {
        DispatchQueue(label: "fetch_latest_queue").async {
            let request = NSFetchRequest<CDMessage>(entityName: CDMessage.className())
            request.fetchLimit = 1
            request.sortDescriptors = [NSSortDescriptor(key: "brokerMetaData.timestamp", ascending: false)]
            do {
                let messages = try self.privateContext.fetch(request)
                guard let message = messages.first else {
                    return
                }
                DispatchQueue.main.async {
                    completion?(message)
                }
            } catch {
            }
        }
    }
}

extension CoreDataManager {
    @objc func mocDidSave(note: Notification) {
        let savedContext = note.object as! NSManagedObjectContext
        
        if savedContext == mainContext {
            return
        }
        
        DispatchQueue.main.async {
            self.mainContext.mergeChanges(fromContextDidSave: note)
        }
    }
    
    /**
     this for reset all data, for testing purpose
     */
    func deleteAllRecords() {
        guard let store = mainContext.persistentStoreCoordinator?.persistentStores.first,
            let storeURL = store.url else {
                return
        }
        
        do {
            try mainContext.persistentStoreCoordinator?.remove(store)
            try FileManager.default.removeItem(at: storeURL)
        } catch {
            print("Delete error \(error)")
        }
        
    }
    
}
