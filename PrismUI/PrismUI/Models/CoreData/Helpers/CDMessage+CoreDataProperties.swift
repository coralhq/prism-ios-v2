//
//  CDMessage+CoreDataProperties.swift
//  PrismUI
//
//  Created by Nanang Rafsanjani on 8/4/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import CoreData


extension CDMessage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDMessage> {
        return NSFetchRequest<CDMessage>(entityName: "CDMessage")
    }

    @NSManaged public var channel: String?
    @NSManaged public var content: NSObject?
    @NSManaged public var conversationID: String?
    @NSManaged public var id: String?
    @NSManaged public var merchantID: String?
    @NSManaged public var sectionDate: Date?
    @NSManaged public var status: Int16
    @NSManaged public var type: String?
    @NSManaged public var version: Int16
    @NSManaged public var brokerMetaData: CDBrokerMetaData?
    @NSManaged public var channelInfo: CDUser?
    @NSManaged public var sender: CDSender?
    @NSManaged public var visitor: CDUser?

}
