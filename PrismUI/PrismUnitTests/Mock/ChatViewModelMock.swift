//
//  ChatViewModelMock.swift
//  PrismUI
//
//  Created by fanni suyuti on 8/9/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import UIKit
import PrismCore
import CoreData

class ChatViewModelMock {
    let message: Message? = Message(dictionary:
        [
            "id": "7ed2ec7e-d1fc-4395-b7c6-225fd313d652",
            "conversation_id": "2baa1dd5-803e-4682-97a6-f58262e44244",
            "merchant_id": "6181dda9-af7d-46fb-a47e-cf4b5be64b42",
            "channel": "LINE",
            "channel_info": [
                "id": "....",
                "name": "....",
            ],
            "sender": [
                "id": "3cee7874-343c-4be1-a12e-ad058d74665e",
                "name": "James Bond",
                "app_name": "Prism Mobile v1.0",
                "role": "agent"
            ],
            "visitor": [
                "id": "ed13265e-fdb3-488c-8d4e-712b5578ec7b",
                "name": "Buyer Wannabe"
            ],
            "type": "text",
            "content": [
                "text": "Hello, World"
            ],
            "version": 2,
            "_broker_metadata": [
                "timestamp": "2016-11-02T07:05:46.827Z"
            ]
        ]
    )
}
