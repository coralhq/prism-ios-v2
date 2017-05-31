//
//  JSONResponseMock.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/30/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation

class JSONResponseMock {
    static var connectResponse: [String: Any] {
        get {
            return [
                "status": "success",
                "message": "OK",
                "data": [
                    "oauth": [
                        "refresh_token": "cd06593d7deb4613be3797b70e351b08",
                        "token_type": "bearer",
                        "access_token": "4f74701be41344af997ccdf7aa7b4071",
                        "client_id": "67ccc85d1d18432b86ac78c342abe1d4",
                        "expires_in": 604800
                    ],
                    "mqtt": [
                        "username": "3abd341d-4da8-4337-975e-b592ae7aca4e",
                        "password": "427a45a5f7c2b7520df97f49d8038622cc48b411b05d31dab9f25db27135b8792e46d5fd5290f2caaf0a62408930decd5a9187db1477da85251025f60f5c9926"
                    ],
                    "visitor": [
                        "id": "3abd341d-4da8-4337-975e-b592ae7aca4e",
                        "name": "Visitor2",
                        "merchant_id": "62ccf49f-0386-49a3-858c-70c98a9dc4fc",
                        "app_name": "paw",
                        "channel_name": "SHAMU",
                        "channel_user_id": "fanni@prismapp.io",
                        "available": true
                    ],
                    "server_timestamp": 1496118271639
                ]
            ]
        }
    }
    
    static var getAttachmentURLResponse: [String: Any] {
        get {
            return [
                "filename": "test.png",
                    "headers": [
                        "Content-Type": "application/octet-stream"
                ]
            ]
        }
    }

    static var createConverationResponse: [String: Any] {
        get {
            return [
                "status": "success",
                "data": [
                    "conversation": [
                        "created_at": "2017-05-19T03:39:31.812Z",
                        "updated_at": "2017-05-19T03:39:31.812Z",
                        "id": "781e9d79-b831-4c6f-b344-8c0f51102fea",
                        "topic": "/chats/8c31f365-05d2-49fe-8c8d-59c84624c870/SHAMU/b09d7f44-3ed9-45cc-855b-281ec7898713",
                        "status": "open",
                        "merchant_id": "8c31f365-05d2-49fe-8c8d-59c84624c870",
                        "has_content": false,
                        "channel": "SHAMU",
                        "visitor": [
                            "created_at": "2017-05-19T03:39:31.808Z",
                            "updated_at": "2017-05-19T03:39:31.808Z",
                            "id": "b09d7f44-3ed9-45cc-855b-281ec7898713",
                            "name": "Visitor Name",
                            "avatar": "",
                            "merchant_id": "8c31f365-05d2-49fe-8c8d-59c84624c870"
                        ],
                        "participants": [
                            [
                                "created_at": "2017-05-19T03:39:31.814Z",
                                "updated_at": "2017-05-19T03:39:31.814Z",
                                "id": "f4a19a4d-04ee-4fe6-89b4-72ed4133ae80",
                                "user_id": "b09d7f44-3ed9-45cc-855b-281ec7898713",
                                "role": "visitor",
                                "conversation_id": "781e9d79-b831-4c6f-b344-8c0f51102fea",
                                "is_read": false
                            ]
                        ],
                        "assignment_histories": [],
                    ]
                ]
            ]
        }
    }
}
