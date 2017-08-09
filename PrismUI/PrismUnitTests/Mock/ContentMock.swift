//
//  ContentMock.swift
//  PrismUI
//
//  Created by fanni suyuti on 8/9/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import Foundation

class ContentMock {
    func text() -> [String: Any] {
        return ["text": "tetext"]
    }
    
    func sticker() -> [String: Any] {
        return [
            "sticker": [
                "created_at": "2017-03-21T11:15:49.165Z",
                "updated_at": "2017-03-21T11:15:49.165Z",
                "id": "10e411c0-9db5-436b-87c3-1811052bac2e",
                "name": "Didu 0",
                "image_url": "https://s3-ap-southeast-1.amazonaws.com/prism-assets-prod/sticker/didu/hello.png",
                "pack_id": "4b1aec21-dee8-4c4a-be1c-8819e9264c25"
            ]
        ]
    }
    
    func invoice() -> [String: Any] {
        return [
            "invoice": [
                "id": "e2asdfdaa-c547-4586-b0ec-d404569c325a",
                "line_items": [
                    [
                        "product": [
                            "id": "e22200aa-c547-4586-b0ec-d404569c325a",
                            "name": "Bebek Laut",
                            "price": "10000",
                            "description": "Bebek laut serbaguna.",
                            "image_urls": [
                                "https://blabla.com/gambar1.png",
                                "https://blabla.com/gambar2.png"
                            ],
                            "discount": [
                                "discount_type": "NOMINAL",
                                "amount": "1000"
                            ],
                            "currency_code": "IDR"
                        ],
                        "quantity": 4
                    ]
                ],
                "grand_total": [
                    "currency_code": "IDR",
                    "amount": "36000"
                ],
                "buyer": [
                    "name": "John",
                    "email": "john@gmail.com",
                    "phone_number": "081234234234"
                ],
                "shipment": [
                    "info": [
                        "customer_name": "John",
                        "customer_email": "john@gmail.com",
                        "customer_address": "Baker Street",
                        "customer_phone": "081234234234"
                    ],
                    "cost": [
                        "currency_code": "IDR",
                        "amount": "5000"
                    ]
                ],
                "payment": [
                    "provider": [
                        "type": "cod"
                    ]
                ]
            ]
        ]
    }
    
    func cart() -> [String: Any] {
        return [
            "cart": [
                "line_items": [
                    [
                        "product": [
                            "id": "e22200aa-c547-4586-b0ec-d404569c325a",
                            "name": "Bebek Laut",
                            "price": "10000",
                            "description": "Bebek laut serbaguna.",
                            "image_urls": [
                                "https://blabla.com/gambar1.png",
                                "https://blabla.com/gambar2.png"
                            ],
                            "discount": [
                                "discount_type": "NOMINAL",
                                "amount": "1000"
                            ],
                            "currency_code": "IDR"
                        ],
                        "quantity": 2
                    ]
                ]
            ]
        ]
    }
    
    func product() -> [String: Any] {
        return [
            "product": [
                "id": "e22200aa-c547-4586-b0ec-d404569c325a",
                "name": "Bebek Laut",
                "price": "10000",
                "description": "Bebek laut serbaguna.",
                "image_urls": [
                "https://blabla.com/gambar1.png",
                "https://blabla.com/gambar2.png"
                ],
                "discount": [
                    "discount_type": "NOMINAL",
                    "amount": "1000"
                ],
                "currency_code": "IDR"
            ]
        ]
    }
    
    func attachment() -> [String: Any] {
        return [
            "attachment": [
                "name": "https://prismapp-staging.s3-ap-southeast-1.com",
                "mimetype": "https://prismapp-staging.s3-ap-southeast-1.com",
                "url": "https://prismapp-staging.s3-ap-southeast-1.com",
                "preview_url": "https://prismapp-staging.s3-ap-southeast-1.com"
            ]
        ]
    }
    
    func offline() -> [String: Any] {
        return [
            "offline_message": [
                "name": "https://prismapp-staging.s3-ap-southeast-1.com",
                "email": "https://prismapp-staging.s3-ap-southeast-1.com",
                "text": "https://prismapp-staging.s3-ap-southeast-1.com",
                "phone": "https://prismapp-staging.s3-ap-southeast-1.com"
            ]
        ]
    }
    
    func close() -> [String: Any] {
        return [
            "close_chat": [
                "message": [
                    "text": "tetext"
                ]
            ]
        ]
    }
}
