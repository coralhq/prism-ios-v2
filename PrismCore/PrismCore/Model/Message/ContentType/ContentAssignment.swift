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
    
    required init?(json: [String: Any]?) {
        guard let assignment = json?["assignment"] as? [String: Any],
            let assignee = assignment["assignee"] as? MessageUser,
            let assignor = assignment["assignor"] as? MessageUser else {
                return nil
        }
        
        self.assignee = assignee
        self.assignor = assignor
    }
}
