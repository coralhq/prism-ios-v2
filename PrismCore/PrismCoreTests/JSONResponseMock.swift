//
//  JSONResponseMock.swift
//  PrismCore
//
//  Created by fanni suyuti on 5/30/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import Foundation
import UIKit

class JSONResponseMock {
    static var attachmentImage:UIImage {
        get {
            return UIImage(named: "tshirt.jpg",
                           in: Bundle.init(for: NetworkMock.self),
                           compatibleWith: nil)!
        }
    }
    static var attachmentURL = URL(string: "http://prismapp.io/shirt.png")!
    static var mqttTopic = "prism_topic"
    static var mqttUsername = "mqtt_username"
    static var mqttPassword = "password"
    
    static var sendTokenResponse: [String: Any] {
        return [
            "status": "success",
            "message": "OK",
            "data": [
                "device_type": "IOS",
                "id": "visitor_id",
                "token": "device_token"
            ]
        ]
    }
    
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
                        "channel_name": PrismChannelName,
                        "channel_user_id": "fanni@prismapp.io",
                        "available": true
                    ],
                    "server_timestamp": 1496118271639
                ]
            ]
        }
    }
    
    static var connectResponseInvalidVisitor: [String: Any] {
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
                    "visitor": ["null":0],
                    "server_timestamp": 1496118271639
                ]
            ]
        }
    }
    
    static var connectResponseInvalidMQTT: [String: Any] {
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
                    "mqtt": ["null":0],
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
            ]
        }
    }
    
    static var connectResponseInvalidOAuth: [String: Any] {
        get {
            return [
                "status": "success",
                "message": "OK",
                "data": [
                    "oauth": ["null":0],
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
            ]
        }
    }
    
    static var getSettingsResponse: [String: Any] {
        get {
            return [
                "status": "success",
                "message": "OK",
                "data": [
                    "public": [
                        "widget": [
                            "enabled": true,
                            "persona_enabled": true,
                            "persona_image_url": "https://s3-ap-southeast-1.amazonaws.com/prismapp-staging/images/01BBRCNEWPNWPW0TW5THRP1QT5/logo.png",
                            "persona_name": "PRISM",
                            "title_expanded": "Let's shop with us!",
                            "subtitle": "Chat to buy",
                            "title_minimized": "Mau pesan? Klik disini",
                            "welcome_message": "Hello, we’re here to make your shopping smoother. Let’s chat!",
                            "offline_form_message": "Hello, We are on offline service now.",
                            "connect_form_message": "hello please fill this form",
                            "style": "CORAL",
                            "attention_grabber": [
                                "option": "TEXT_AND_IMAGE",
                                "desktop_text": "PRISM IS AWESOME",
                                "desktop_image_url": "https://s3-ap-southeast-1.amazonaws.com/prismapp-staging/images/01BBT91DXERBDS1NQM22JJ04GA/Group @2x.png",
                                "mobile_text": "PRISM IS AWESOME",
                                "mobile_image_url": "https://s3-ap-southeast-1.amazonaws.com/prismapp-staging/images/01BBRH08W35SGA1HQQK1SB10KX/ag-test-2.png"
                            ],
                            "offline_message": "Informasi data dan pesan yang Anda kirim sudah kami terima. Kami akan menghubungi Anda segera.",
                            "working_hours": [
                                "monday": [
                                    [
                                        "from": "00:00",
                                        "to": "23:59"
                                    ]
                                ],
                                "tuesday": [
                                    [
                                        "from": "00:00",
                                        "to": "23:59"
                                    ]
                                ],
                                "wednesday": [
                                    [
                                        "from": "00:00",
                                        "to": "23:59"
                                    ]
                                ],
                                "thursday": [
                                    [
                                        "from": "00:00",
                                        "to": "23:59"
                                    ]
                                ],
                                "friday": [
                                    [
                                        "from": "00:00",
                                        "to": "23:59"
                                    ]
                                ],
                                "saturday": [
                                    [
                                        "from": "00:00",
                                        "to": "23:59"
                                    ]
                                ],
                                "sunday": [
                                    [
                                        "from": "00:00",
                                        "to": "23:59"
                                    ]
                                ]
                            ],
                            "position": "bottom-right",
                            "input_form": "ENABLED",
                            "input_form_field": [
                                "name": [
                                    "show": true,
                                    "required": true
                                ],
                                "phone": [
                                    "show": true,
                                    "required": true
                                ],
                                "email": [
                                    "show": true,
                                    "required": true
                                ]
                            ],
                            "timezone": "Asia/Jakarta",
                            "triggers": [
                                [
                                    "url": "https://waldo.staging.coral-inc.com/prism",
                                    "wait_time": "20"
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        }
    }
    
    static var getAttachmentURLResponse: [String: Any] {
        get {
            return [
                "status": "success",
                "data": [
                    "upload_url": "https://prismapp-staging.s3-ap-southeast-1.com"
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
            ]
        }
    }
    
    static var createConverationResponseInvalidVisitor: [String: Any] {
        get {
            return [
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
                            "created_at": "2017"
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
    
    static var createConverationResponseInvalidParticipant: [String: Any] {
        get {
            return [
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
                                "created_at": "201"
                            ]
                        ],
                        "assignment_histories": [],
                    ]
                ]
            ]
        }
    }
    
    static var getConversationHistoryResponse: [String: Any] {
        get {
            return Utils.jsonObject(from: "conversationHistory") as! [String : Any]
        }
    }
    
    static var getMessageResponse: [String: Any] {
        get {
            return Utils.jsonObject(from: "messageResponse") as! [String : Any]
        }
    }
    
    static var getConversationHistoryResponseInvalidMessage: [String: Any] {
        get {
            return [
                "status": "success",
                "data": [
                    "messages": [
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
                        ], ["null":""]
                    ]
                ]
            ]
        }
    }
    
    static var getStickersResponse: [String: Any] {
        get {
            return [
                "status": "success",
                "data": [
                    "packs": [
                        [
                            "created_at": "2017-03-21T11:15:49.165Z",
                            "updated_at": "2017-03-21T11:15:49.165Z",
                            "id": "4b1aec21-dee8-4c4a-be1c-8819e9264c25",
                            "name": "Didu",
                            "logo_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/didu/hello.png",
                            "created_by": "PRISM",
                            "is_public": true,
                            "stickers": [
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "10e411c0-9db5-436b-87c3-1811052bac2e",
                                    "name": "Didu 0",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/didu/hello.png",
                                    "pack_id": "4b1aec21-dee8-4c4a-be1c-8819e9264c25"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "10d754b2-b57a-4ab9-ac11-20802414eb10",
                                    "name": "Didu 1",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/didu/thinking.png",
                                    "pack_id": "4b1aec21-dee8-4c4a-be1c-8819e9264c25"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "374208d5-f547-4f90-85ca-ecff0fa7c1a5",
                                    "name": "Didu 2",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/didu/kiss.png",
                                    "pack_id": "4b1aec21-dee8-4c4a-be1c-8819e9264c25"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "bda07dbb-4003-4c89-9a72-c939a7c3f0fb",
                                    "name": "Didu 3",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/didu/invoice_1.png",
                                    "pack_id": "4b1aec21-dee8-4c4a-be1c-8819e9264c25"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "70ad35fe-240c-43b7-97b7-407db9e320e2",
                                    "name": "Didu 4",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/didu/shocked_1.png",
                                    "pack_id": "4b1aec21-dee8-4c4a-be1c-8819e9264c25"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "fd760599-247f-4da7-b889-e026d3ab5b20",
                                    "name": "Didu 5",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/didu/thumbs_up.png",
                                    "pack_id": "4b1aec21-dee8-4c4a-be1c-8819e9264c25"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "ba003d38-2cf6-439a-9bb1-bde0900db9ef",
                                    "name": "Didu 6",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/didu/packing_1.png",
                                    "pack_id": "4b1aec21-dee8-4c4a-be1c-8819e9264c25"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "d701c395-0fdb-449d-8a40-94a42728eacd",
                                    "name": "Didu 7",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/didu/disappointed.png",
                                    "pack_id": "4b1aec21-dee8-4c4a-be1c-8819e9264c25"
                                ]
                            ]
                        ],
                        [
                            "created_at": "2017-03-21T11:15:49.165Z",
                            "updated_at": "2017-03-21T11:15:49.165Z",
                            "id": "943ad07e-2681-4f14-a125-6088266e9617",
                            "name": "Dea",
                            "logo_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/dea/thumbs%20up.png",
                            "created_by": "PRISM",
                            "is_public": true,
                            "stickers": [
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "2cce9280-59bc-4141-aa09-8404eefe60e6",
                                    "name": "Dea 0",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/dea/sorry.png",
                                    "pack_id": "943ad07e-2681-4f14-a125-6088266e9617"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "9b49129d-d458-4456-a694-7674440a4019",
                                    "name": "Dea 1",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/dea/thumbs%20up.png",
                                    "pack_id": "943ad07e-2681-4f14-a125-6088266e9617"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "50ec5d9c-6157-4fd6-8861-25d6035dca21",
                                    "name": "Dea 2",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/dea/packing.png",
                                    "pack_id": "943ad07e-2681-4f14-a125-6088266e9617"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "25987b88-b394-4804-ae6b-9602e9a1179d",
                                    "name": "Dea 3",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/dea/payment_received.png",
                                    "pack_id": "943ad07e-2681-4f14-a125-6088266e9617"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "f6cabba6-9e0b-499f-92b3-6dcfbdeaf224",
                                    "name": "Dea 4",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/dea/search.png",
                                    "pack_id": "943ad07e-2681-4f14-a125-6088266e9617"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "8195bf17-3c8e-4479-bb06-9c9186876015",
                                    "name": "Dea 5",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/dea/love.png",
                                    "pack_id": "943ad07e-2681-4f14-a125-6088266e9617"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "786ac147-ae9b-4da8-ac44-bc75a30de782",
                                    "name": "Dea 6",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/dea/shocked.png",
                                    "pack_id": "943ad07e-2681-4f14-a125-6088266e9617"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "3903e8e4-9c88-4a84-a8dc-7ceafbf41ecc",
                                    "name": "Dea 7",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/dea/invoice.png",
                                    "pack_id": "943ad07e-2681-4f14-a125-6088266e9617"
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        }
    }
    
    static var getStickersResponseInvalidPack: [String: Any] {
        get {
            return [
                "status": "success",
                "data": [
                    "packs": [
                        [
                            "is_public": true,
                            "stickers": [
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "10e411c0-9db5-436b-87c3-1811052bac2e",
                                    "name": "Didu 0",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/didu/hello.png",
                                    "pack_id": "4b1aec21-dee8-4c4a-be1c-8819e9264c25"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "10d754b2-b57a-4ab9-ac11-20802414eb10",
                                    "name": "Didu 1",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/didu/thinking.png",
                                    "pack_id": "4b1aec21-dee8-4c4a-be1c-8819e9264c25"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "374208d5-f547-4f90-85ca-ecff0fa7c1a5",
                                    "name": "Didu 2",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/didu/kiss.png",
                                    "pack_id": "4b1aec21-dee8-4c4a-be1c-8819e9264c25"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "bda07dbb-4003-4c89-9a72-c939a7c3f0fb",
                                    "name": "Didu 3",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/didu/invoice_1.png",
                                    "pack_id": "4b1aec21-dee8-4c4a-be1c-8819e9264c25"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "70ad35fe-240c-43b7-97b7-407db9e320e2",
                                    "name": "Didu 4",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/didu/shocked_1.png",
                                    "pack_id": "4b1aec21-dee8-4c4a-be1c-8819e9264c25"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "fd760599-247f-4da7-b889-e026d3ab5b20",
                                    "name": "Didu 5",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/didu/thumbs_up.png",
                                    "pack_id": "4b1aec21-dee8-4c4a-be1c-8819e9264c25"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "ba003d38-2cf6-439a-9bb1-bde0900db9ef",
                                    "name": "Didu 6",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/didu/packing_1.png",
                                    "pack_id": "4b1aec21-dee8-4c4a-be1c-8819e9264c25"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "d701c395-0fdb-449d-8a40-94a42728eacd",
                                    "name": "Didu 7",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/didu/disappointed.png",
                                    "pack_id": "4b1aec21-dee8-4c4a-be1c-8819e9264c25"
                                ]
                            ]
                        ],
                        [
                            "created_at": "2017-03-21T11:15:49.165Z",
                            "updated_at": "2017-03-21T11:15:49.165Z",
                            "id": "943ad07e-2681-4f14-a125-6088266e9617",
                            "name": "Dea",
                            "logo_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/dea/thumbs%20up.png",
                            "created_by": "PRISM",
                            "is_public": true,
                            "stickers": [
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "2cce9280-59bc-4141-aa09-8404eefe60e6",
                                    "name": "Dea 0",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/dea/sorry.png",
                                    "pack_id": "943ad07e-2681-4f14-a125-6088266e9617"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "9b49129d-d458-4456-a694-7674440a4019",
                                    "name": "Dea 1",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/dea/thumbs%20up.png",
                                    "pack_id": "943ad07e-2681-4f14-a125-6088266e9617"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "50ec5d9c-6157-4fd6-8861-25d6035dca21",
                                    "name": "Dea 2",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/dea/packing.png",
                                    "pack_id": "943ad07e-2681-4f14-a125-6088266e9617"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "25987b88-b394-4804-ae6b-9602e9a1179d",
                                    "name": "Dea 3",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/dea/payment_received.png",
                                    "pack_id": "943ad07e-2681-4f14-a125-6088266e9617"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "f6cabba6-9e0b-499f-92b3-6dcfbdeaf224",
                                    "name": "Dea 4",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/dea/search.png",
                                    "pack_id": "943ad07e-2681-4f14-a125-6088266e9617"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "8195bf17-3c8e-4479-bb06-9c9186876015",
                                    "name": "Dea 5",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/dea/love.png",
                                    "pack_id": "943ad07e-2681-4f14-a125-6088266e9617"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "786ac147-ae9b-4da8-ac44-bc75a30de782",
                                    "name": "Dea 6",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/dea/shocked.png",
                                    "pack_id": "943ad07e-2681-4f14-a125-6088266e9617"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "3903e8e4-9c88-4a84-a8dc-7ceafbf41ecc",
                                    "name": "Dea 7",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/dea/invoice.png",
                                    "pack_id": "943ad07e-2681-4f14-a125-6088266e9617"
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        }
    }
    
    static var getStickersResponseInvalidStickers: [String: Any] {
        get {
            return [
                "status": "success",
                "data": [
                    "packs": [
                        [
                            "created_at": "2017-03-21T11:15:49.165Z",
                            "updated_at": "2017-03-21T11:15:49.165Z",
                            "id": "4b1aec21-dee8-4c4a-be1c-8819e9264c25",
                            "name": "Didu",
                            "logo_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/didu/hello.png",
                            "created_by": "PRISM",
                            "is_public": true,
                            "stickers": [
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "10e411c0-9db5-436b-87c3-1811052bac2e",
                                    "name": "Didu 0",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/didu/hello.png",
                                    "pack_id": "4b1aec21-dee8-4c4a-be1c-8819e9264c25"
                                ],
                                [
                                    "created_at": "20"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "374208d5-f547-4f90-85ca-ecff0fa7c1a5",
                                    "name": "Didu 2",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/didu/kiss.png",
                                    "pack_id": "4b1aec21-dee8-4c4a-be1c-8819e9264c25"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "bda07dbb-4003-4c89-9a72-c939a7c3f0fb",
                                    "name": "Didu 3",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/didu/invoice_1.png",
                                    "pack_id": "4b1aec21-dee8-4c4a-be1c-8819e9264c25"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "70ad35fe-240c-43b7-97b7-407db9e320e2",
                                    "name": "Didu 4",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/didu/shocked_1.png",
                                    "pack_id": "4b1aec21-dee8-4c4a-be1c-8819e9264c25"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "fd760599-247f-4da7-b889-e026d3ab5b20",
                                    "name": "Didu 5",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/didu/thumbs_up.png",
                                    "pack_id": "4b1aec21-dee8-4c4a-be1c-8819e9264c25"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "ba003d38-2cf6-439a-9bb1-bde0900db9ef",
                                    "name": "Didu 6",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/didu/packing_1.png",
                                    "pack_id": "4b1aec21-dee8-4c4a-be1c-8819e9264c25"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "d701c395-0fdb-449d-8a40-94a42728eacd",
                                    "name": "Didu 7",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/didu/disappointed.png",
                                    "pack_id": "4b1aec21-dee8-4c4a-be1c-8819e9264c25"
                                ]
                            ]
                        ],
                        [
                            "created_at": "2017-03-21T11:15:49.165Z",
                            "updated_at": "2017-03-21T11:15:49.165Z",
                            "id": "943ad07e-2681-4f14-a125-6088266e9617",
                            "name": "Dea",
                            "logo_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/dea/thumbs%20up.png",
                            "created_by": "PRISM",
                            "is_public": true,
                            "stickers": [
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "2cce9280-59bc-4141-aa09-8404eefe60e6",
                                    "name": "Dea 0",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/dea/sorry.png",
                                    "pack_id": "943ad07e-2681-4f14-a125-6088266e9617"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "9b49129d-d458-4456-a694-7674440a4019",
                                    "name": "Dea 1",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/dea/thumbs%20up.png",
                                    "pack_id": "943ad07e-2681-4f14-a125-6088266e9617"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "50ec5d9c-6157-4fd6-8861-25d6035dca21",
                                    "name": "Dea 2",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/dea/packing.png",
                                    "pack_id": "943ad07e-2681-4f14-a125-6088266e9617"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "25987b88-b394-4804-ae6b-9602e9a1179d",
                                    "name": "Dea 3",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/dea/payment_received.png",
                                    "pack_id": "943ad07e-2681-4f14-a125-6088266e9617"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "f6cabba6-9e0b-499f-92b3-6dcfbdeaf224",
                                    "name": "Dea 4",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/dea/search.png",
                                    "pack_id": "943ad07e-2681-4f14-a125-6088266e9617"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "8195bf17-3c8e-4479-bb06-9c9186876015",
                                    "name": "Dea 5",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/dea/love.png",
                                    "pack_id": "943ad07e-2681-4f14-a125-6088266e9617"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "786ac147-ae9b-4da8-ac44-bc75a30de782",
                                    "name": "Dea 6",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/dea/shocked.png",
                                    "pack_id": "943ad07e-2681-4f14-a125-6088266e9617"
                                ],
                                [
                                    "created_at": "2017-03-21T11:15:49.165Z",
                                    "updated_at": "2017-03-21T11:15:49.165Z",
                                    "id": "3903e8e4-9c88-4a84-a8dc-7ceafbf41ecc",
                                    "name": "Dea 7",
                                    "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/dea/invoice.png",
                                    "pack_id": "943ad07e-2681-4f14-a125-6088266e9617"
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        }
    }
    
    static var refreshTokenResponse: [String: Any] {
        get {
            return [
                "status" : "success",
                "message" : "amajing",
                "data" : [
                    "oauth" : [
                        "refresh_token": "cd06593d7deb4613be3797b70e351b08",
                        "token_type": "bearer",
                        "access_token": "4f74701be41344af997ccdf7aa7b4071",
                        "client_id": "67ccc85d1d18432b86ac78c342abe1d4",
                        "expires_in": 604800
                    ]
                ]
            ]
        }
    }
    
}
