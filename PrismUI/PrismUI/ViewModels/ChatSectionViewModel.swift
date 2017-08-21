//
//  ChatSectionViewModel.swift
//  PrismUI
//
//  Created by fanni suyuti on 8/9/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ChatSectionViewModel {
    var indexTitle: String?
    var objects: [ChatViewModel]?
    
    init(info: NSFetchedResultsSectionInfo) {
        guard let messages = info.objects as? [CDMessage] else { return }
        
        objects = []
        for message in messages {
            guard let credential = Vendor.shared.credential,
                let vm = ChatViewModel(message: message, visitor: credential.sender) else { return }
            objects?.append(vm)
        }
        
        guard let date = messages.first?.sectionDate else { return }
        if Vendor.shared.calendar.isDate(date, equalTo: Date(), toGranularity: .year) {
            indexTitle = date.day()
        } else {
            indexTitle = date.dayWithYear()
        }
    }
}
