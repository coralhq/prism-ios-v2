//
//  MessageAssignment.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/26/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

class ContentAssignment: MessageContentMappable {
    let assignee: MessageUser
    let assignor: MessageUser
    
    required init?(dictionary: [String: Any]?) {
        guard let assignment = dictionary?["assignment"] as? [String: Any],
            let assignee = assignment["assignee"] as? [String: Any],
            let assignor = assignment["assignor"] as? [String: Any],
            let userAssignee = MessageUser(dictionary: assignee),
            let userAssignor = MessageUser(dictionary: assignor) else {
                return nil
        }
        self.assignee = userAssignee
        self.assignor = userAssignor
    }
    
    func dictionaryValue() -> [String : Any] {
        return ["assignment": ["assignee": assignee.dictionaryValue(),
                               "assignor": assignor.dictionaryValue()]]
    }
}
