//
//  DepartmentListResponse.swift
//  PrismCore
//
//  Created by Nanang Rafsanjani on 06/07/18.
//  Copyright © 2018 PrismApp. All rights reserved.
//

import UIKit

open
class Agent: NSObject, Mappable {
    public let createdAt: Date
    public let updatedAt: Date
    public let id: String
    public let name: String
    public let avatar: String
    public let email: String
    public let merchantID: String
    public let agentType: String
    
    required public init?(dictionary: [String : Any]?) {
        guard let createdAt = (dictionary?["created_at"] as? String)?.ISO8601Date,
            let updatedAt = (dictionary?["updated_at"] as? String)?.ISO8601Date,
            let id = dictionary?["id"] as? String,
            let name = dictionary?["name"] as? String,
            let avatar = dictionary?["avatar"] as? String,
            let email = dictionary?["email"] as? String,
            let merchantID = dictionary?["merchant_id"] as? String,
            let agentType = dictionary?["agent_type"] as? String
            else {
                return nil
        }
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.id = id
        self.name = name
        self.avatar = avatar
        self.email = email
        self.merchantID = merchantID
        self.agentType = agentType
    }
    
    public func dictionaryValue() -> [String : Any] {
        return [
            "created_at": createdAt.ISO8601String,
            "updated_at": updatedAt.ISO8601String,
            "id": id,
            "name": name,
            "avatar": avatar,
            "email": email,
            "merchant_id": merchantID,
            "agent_type": agentType
        ]
    }
    
    
}

open
class Department: NSObject, Mappable {
    public let createdAt: Date
    public let updatedAt: Date
    public let id: String
    public let merchantID: String
    public let name: String
    public let isActive: Bool
    
    public required init?(dictionary: [String : Any]?) {
        guard let createdAt = (dictionary?["created_at"] as? String)?.ISO8601Date,
            let updatedAt = (dictionary?["updated_at"] as? String)?.ISO8601Date,
            let id = dictionary?["id"] as? String,
            let merchantID = dictionary?["merchant_id"] as? String,
            let name = dictionary?["name"] as? String,
            let isActive = dictionary?["is_active"] as? Bool
            else {
                return nil
        }
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.id = id
        self.name = name
        self.merchantID = merchantID
        self.isActive = isActive
    }
    
    public func dictionaryValue() -> [String : Any] {
        return [
            "created_at": createdAt.ISO8601String,
            "updated_at": updatedAt.ISO8601String,
            "id": id,
            "merchant_id": merchantID,
            "name": name,
            "is_active": isActive
        ]
    }
}

open
class DepartmentListResponse: NSObject, Mappable {
    public let departments: [Department]
    
    public required init?(dictionary: [String : Any]?) {
        guard let data = dictionary?["data"] as? [String: Any],
            let departments = data["departments"] as? [[String: Any]] else {
                return nil
        }
        self.departments = departments.map({ Department(dictionary: $0)! })
    }
    
    public func dictionaryValue() -> [String : Any] {
        return [
            "departments": departments.map({ $0.dictionaryValue() })
        ]
    }
}
