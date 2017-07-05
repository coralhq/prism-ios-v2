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
    let credential: PrismCredential
    
    var delegate: ChatQueryManagerDelegate?
    
    var sections: [ChatSectionViewModel] = []
    
    init(context: NSManagedObjectContext, credential: PrismCredential) {
        self.context = context
        self.credential = credential
        
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
            guard let sections = fetchController.sections else { return }
            
            self.sections.removeAll()
            for sectionInfo in sections {
                self.sections.append(ChatSectionViewModel(info: sectionInfo, credential: credential))
            }
        } catch {
            print("fetch error: \(error)")
        }
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
            sections.insert(ChatSectionViewModel(info: sectionInfo, credential: credential), at: sectionIndex)
        case .update:
            sections.remove(at: sectionIndex)
            sections.insert(ChatSectionViewModel(info: sectionInfo, credential: credential), at: sectionIndex)
        default:
            break
        }
        
        delegate?.changedSection(at: sectionIndex, changeType: ChatChangeType.convertedFrom(type: type))
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        guard let newIndexPath = newIndexPath,
            let sectionInfo = controller.sections?[newIndexPath.section],
            let message = sectionInfo.objects?[newIndexPath.row] as? CDMessage,
            var objects = sections[newIndexPath.section].objects else { return }
        
        let index = newIndexPath.row
        let chatVM = ChatViewModel(message: message, visitor: credential.sender)
        
        switch type {
        case .delete:
            objects.remove(at: index)
        case .insert:
            objects.insert(viewModel: chatVM, at: index)
        case .update:
            objects.update(viewModel: chatVM, at: index)
        case .move:
            guard let indexPath = indexPath else { return }
            objects.remove(at: indexPath.row)
            objects.insert(chatVM, at: index)
        }
        
        sections[newIndexPath.section].objects = objects
        
        delegate?.changedObject(at: indexPath, newIndexPath: newIndexPath, changeType: ChatChangeType.convertedFrom(type: type))
    }
}
