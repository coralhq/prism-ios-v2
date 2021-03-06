//
//  ChatQueryManager.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 7/11/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import CoreData

enum ChatChangeType {
    case insert
    case delete
    case update
    case move
    
    static func convertedFrom(type: NSFetchedResultsChangeType) -> ChatChangeType {
        switch type {
        case .delete:
            return ChatChangeType.delete
        case .insert:
            return ChatChangeType.insert
        case .move:
            return ChatChangeType.move
        case .update:
            return ChatChangeType.update
        }
    }
}

protocol ChatQueryManagerDelegate: class {
    func didChange()
    func willChange()
    func changedSection(at section: Int, changeType: ChatChangeType)
    func changedObject(at indexPath: IndexPath?, newIndexPath: IndexPath?, changeType: ChatChangeType)
}

class ChatQueryManager: NSObject, NSFetchedResultsControllerDelegate {
    let context: NSManagedObjectContext
    let fetchController: NSFetchedResultsController<CDMessage>
    
    weak var delegate: ChatQueryManagerDelegate?
    
    var sections: [ChatSectionViewModel] = []
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        let request = NSFetchRequest<CDMessage>(entityName: CDMessage.className())
        request.sortDescriptors = [NSSortDescriptor(key: "brokerMetaData.timestamp", ascending: false)]
        fetchController = NSFetchedResultsController(fetchRequest: request,
                                                     managedObjectContext: context,
                                                     sectionNameKeyPath: "sectionDate",
                                                     cacheName: nil)
        
        super.init()
        
        fetchController.delegate = self
    }

    func fetchSections() {
        do {
            try fetchController.performFetch()
            modelMessageObjects()
        } catch {
            print("fetch error: \(error)")
        }
    }
    
    func modelMessageObjects() {
        guard let sections = fetchController.sections else {
            return
        }
        var models: [ChatSectionViewModel] = []
        for sectionInfo in sections {
            models.append(ChatSectionViewModel(info: sectionInfo))
        }
        self.sections = models
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didChange()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.willChange()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .delete:
            sections.remove(at: sectionIndex)
        case .insert:
            sections.insert(ChatSectionViewModel(info: sectionInfo), at: sectionIndex)
        case .update:
            sections.remove(at: sectionIndex)
            sections.insert(ChatSectionViewModel(info: sectionInfo), at: sectionIndex)
        default:
            break
        }
        
        delegate?.changedSection(at: sectionIndex, changeType: ChatChangeType.convertedFrom(type: type))
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        modelMessageObjects()
        delegate?.changedObject(at: indexPath, newIndexPath: newIndexPath, changeType: ChatChangeType.convertedFrom(type: type))
    }
}
