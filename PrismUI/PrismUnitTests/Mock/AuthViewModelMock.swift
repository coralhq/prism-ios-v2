//
//  AuthViewModelMock.swift
//  PrismUI
//
//  Created by fanni suyuti on 8/9/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation
import PrismCore

enum ThemeTypeMock: String {
    case PINK
    case WHITE
    case BLACK
    case BLUE
    case GREEN
    case CORAL
    case YELLOW
    case RED
}

class AuthViewModelMock {
    
    func getInvalidSetting() -> [String: Any] {
        return [:]
    }
    
    func getSetting(type: ThemeTypeMock) -> [String: Any] {
        return [
            "widget":[
                "enabled": true,
                "visitor_connect": [
                    "option": "DISABLED|ENABLED",
                    "form_message": "Hello, we’re here to make your shopping smoother. Let’s chat!",
                    "form_options": [
                        "name": [
                            "show":false,
                            "required":false
                        ],
                        "phone": [
                            "show":false,
                            "required":false
                        ],
                        "email": [
                            "show":false,
                            "required":false
                        ]
                    ]
                ],
                "appearance": [
                    "persona": [
                        "enabled":false,
                        "image_url":"https://img.com/avatar.png",
                        "name":"Danny"
                    ],
                    "texts": [
                        "title_expanded": "Let`s shop with us!",
                        "subtitle": "Chat to buy",
                        "title_minimized": "Mau pesan? Klik disini",
                        "welcome_message": "Hello, we’re here to make your shopping smoother. Let’s chat!"
                    ],
                    "color_theme": type.rawValue,
                    "position": "bottom-right"
                ],
                "attention_grabber":[
                    "option":"DISABLED|TEXT|IMAGE|TEXT_AND_IMAGE",
                    "desktop_text":"PRISM IS YOUR CONVERSION RATE BOOSTER",
                    "desktop_image_url":"https://img.com/attention-grabber-desktop.png",
                    "mobile_text":"PRISM IS YOUR CONVERSION RATE BOOSTER",
                    "mobile_image_url":"https://img.com/attention-grabber-desktop.png"
                ],
                "working_hours":[
                    "monday":[
                        [
                            "from":"08:00",
                            "to":"12:00"
                        ],
                        [
                            "from":"13:00",
                            "to":"18:00"
                        ]
                    ],
                    "tuesday":[
                        [
                            "from":"08:00",
                            "to":"12:00"
                        ],
                        [
                            "from":"13:00",
                            "to":"18:00"
                        ]
                        ],
                    "wednesday":[
                        [
                            "from":"08:00",
                            "to":"12:00"
                        ],
                        [
                            "from":"13:00",
                            "to":"18:00"
                        ]
                    ],
                    "thursday":[
                        [
                        "from":"08:00",
                        "to":"12:00"
                        ],
                        [
                        "from":"13:00",
                        "to":"18:00"
                        ]
                    ],
                    "friday":[
                        [
                            "from":"08:00",
                            "to":"12:00"
                        ],
                        [
                            "from":"13:00",
                            "to":"18:00"
                        ]
                    ],
                    "saturday":[],
                    "sunday":[]
                ],
                "offline_widget":[
                    "texts":[
                        "equals_title_minimized": false,
                        "equals_title_expanded": false,
                        "title_expanded":"We’re Offline, leave us a message",
                        "title_minimized":"We’re Offline, leave us a message",
                        "offline_message":"Hello, our chat service is closed now. Please leave a message, we will contact you as soon as we’re back",
                        "offline_message_confirmation": "Thank you for contact us"
                    ],
                    "form_options":[
                        "name":[
                            "show":false,
                            "required":false
                        ],
                        "phone":[
                            "show":false,
                            "required":false
                        ],
                        "email":[
                            "show":false,
                            "required":false
                        ]
                    ]
                ],
                "triggers": [
                    [
                        "url": "http://prismapp.io/trigger",
                        "wait_time": "5",
                        "action": "Widget Expanded|Widget Minimized",
                        "enabled": true
                    ],
                    [
                        "url": "http://prismapp.io/products",
                        "wait_time": "15",
                        "action": "Widget Expanded|Widget Minimized",
                        "enabled": true
                    ]
                ],
                "auto_responders":[  
                    [
                        "channel_id": "123674762",
                        "channel_type": "SHAMU|LINE|FACEBOOK",
                        "condition": "When Online|When Offline",
                        "response_message": "Welcome to Prismshop, what can we do for you today?",
                        "enabled": true
                    ]
                ]
            ]
        ]
    }
    
    func getConnectResponse(valid: Bool) -> ConnectResponse? {
        if !valid {
            return ConnectResponse(dictionary: [:])
        }
        
        let result = ConnectResponse(dictionary: [
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
                    "channel_name": PrismChannelName,
                    "channel_user_id": "fanni@prismapp.io",
                    "available": true
                ],
                "server_timestamp": 1496118271639
            ]
        ])
        
        return result
    }
    
    func getCreateConversationResponse(valid: Bool) -> CreateConversationResponse? {
        if !valid {
            return CreateConversationResponse(dictionary: [:])
        }
        
        let result = CreateConversationResponse(dictionary: [
            "status": "success",
            "data": [
                "conversation": [
                    "created_at": "2017-05-19T03:39:31.812Z",
                    "updated_at": "2017-05-19T03:39:31.812Z",
                    "id": "781e9d79-b831-4c6f-b344-8c0f51102fea",
                    "topic": "/chats/8c31f365-05d2-49fe-8c8d-59c84624c870/PrismChannelName/b09d7f44-3ed9-45cc-855b-281ec7898713",
                    "status": "open",
                    "merchant_id": "8c31f365-05d2-49fe-8c8d-59c84624c870",
                    "has_content": false,
                    "channel": PrismChannelName,
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
        ])
        
        return result
    }
}
