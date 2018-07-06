//
//  AssignByDepartmentEndPoint.swift
//  PrismCore
//
//  Created by Nanang Rafsanjani on 06/07/18.
//  Copyright © 2018 PrismApp. All rights reserved.
//

import UIKit

class AssignByDepartmentEndPoint: EndPoint {
    
    let departmentID: String
    let conversationID: String
    
    var url: URL {
        get {
            return URL.assignByDepartment
        }
    }
    
    var method = HTTPMethod.POST
    var token: String?
    var httpBody: [String : Any] {
        get {
            return [
                "department_id": departmentID,
                "conversation_id": conversationID
            ]
        }
    }
    
    var contentType: String? {
        get {
            return "application/json"
        }
    }
    
    init(withToken token: String, departmentID: String, conversationID: String) {
        self.token = token
        self.departmentID = departmentID
        self.conversationID = conversationID
    }
}
