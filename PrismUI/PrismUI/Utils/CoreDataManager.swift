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
    static var shared = CoreDataManager()
    
    var mainContext: NSManagedObjectContext
    
    var dbPath: URL? {
        guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return docURL.appendingPathComponent("prism_sdk.sqlite")
    }
    
    var newContext: NSManagedObjectContext {
        get {
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.persistentStoreCoordinator = self.mainContext.persistentStoreCoordinator
            return context
        }
    }
    
    init() {
        mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        let modelURL = Bundle.prism.url(forResource: "Chat", withExtension: "momd")!
        let model = NSManagedObjectModel(contentsOf: modelURL)!
        
        do {
            let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
            mainContext.persistentStoreCoordinator = psc
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: dbPath, options: nil)
        } catch {
            print("Error: \(error)")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(mocDidSave(note:)), name: .NSManagedObjectContextDidSave, object: nil)
    }
    
    func clearData() {
        guard let psc = mainContext.persistentStoreCoordinator,
            let path = dbPath else {
                return
        }
        do {
            try psc.destroyPersistentStore(at: path, ofType: NSSQLiteStoreType, options: nil)
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: path, options: nil)
        } catch {
            print("Error: \(error)")
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func save() {
        guard mainContext.hasChanges else {
            return
        }
        do {
            try mainContext.save()
        } catch {
            print("Error \(error)")
        }
    }
    
    @discardableResult
    func buildMessage(message: Message) -> CDMessage {
        var cdmsg = fetchMessage(identifier: message.id, context: mainContext)
        if cdmsg == nil {
            cdmsg = CDMessage(with: mainContext, dictionary: message.dictionaryValue())
        } else {
            cdmsg?.updateMessage(with: message.dictionaryValue())
        }
        return cdmsg!
    }
    
    func saveMessages(messages: [Message]) {
        DispatchQueue(label: "save_queue").async {
            let context = self.newContext
            
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
    
    func fetchMessage(identifier: String, context: NSManagedObjectContext) -> CDMessage? {
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: CDMessage.className())
        req.predicate = NSPredicate(format: "id == %@", identifier)
        do {
            return try context.fetch(req).first as? CDMessage
        } catch {
            return nil
        }
    }
    
    func fetchPendingMessages(completion:(([CDMessage]?) -> ())?) {
        let request = NSFetchRequest<CDMessage>(entityName: CDMessage.className())
        request.predicate = NSPredicate(format: "status == %i", MessageStatus.pending.rawValue)
        fetchMessage(request: request, completion: completion)
    }
    
    func fetchLatestMessage(completion:((CDMessage?) -> ())?) {
        let request = NSFetchRequest<CDMessage>(entityName: CDMessage.className())
        request.fetchLimit = 1
        request.sortDescriptors = [NSSortDescriptor(key: "brokerMetaData.timestamp", ascending: false)]
        fetchMessage(request: request) { (messages) in
            completion?(messages?.first)
        }
    }
    
    private func fetchMessage(request: NSFetchRequest<CDMessage>, completion:(([CDMessage]?) -> ())?) {
        let context = self.newContext
        let fetcher = NSAsynchronousFetchRequest(fetchRequest: request) { (result) in
            DispatchQueue.main.async {
                completion?(result.finalResult)
            }
        }
        do {
            try context.execute(fetcher)
        } catch {
            completion?(nil)
            print("Error \(error)")
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
}
