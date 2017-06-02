//
//  PrismCoreTests.swift
//  PrismCoreTests
//
//  Created by fanni suyuti on 5/24/17.
//  Copyright © 2017 PrismApp. All rights reserved.
//

import XCTest
@testable import PrismCore

class PrismCoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        Config.shared.configure(environment: .Sandbox, merchantID: "")
        PrismCore.shared.network = NetworkMock.shared
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testConfigure() {
        let delegate = TestDelegate()
        PrismCore.shared.configure(environment: .Sandbox, merchantID: "", delegate: delegate)
        XCTAssertNotNil(Config.shared.getEnvironment())
        XCTAssertNotNil(Config.shared.getMerchantID())
    }
    
    func testVisitorConnect() {
        PrismCore.shared.visitorConnect(visitorName: "asdasdasd", userID: "asdasd") { (response, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
        }
    }
    
    func testAnnonymousVisitorConnect() {
        PrismCore.shared.annonymousVisitorConnect { (response, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
        }
    }
    
    func testConnectToBroker() -> Void {
        PrismCore.shared.connectToBroker(username: JSONResponseMock.mqttUsername, password: JSONResponseMock.mqttPassword, completionHandler: {(connected, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(connected)
        })
    }

    func testGetSettings() {
        PrismCore.shared.getSettings() { (response, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
        }
    }
    
    func testGetAttachmentURL() {
        PrismCore.shared.getAttachmentURL(filename: "", conversationID: "", token: "") { (response, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
        }
    }

    func testCreateConversation() {
        PrismCore.shared.createConversation(visitorName: "", token: "") { (response, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
        }
    }
    
    func testPublishPlainTextMessage() {
        var message: Message?
        guard let channelInfo = MessageChannelInfo(id: "", name: ""),
            let visitor = MessageVisitorInfo(id: "", name: ""),
            let sender = MessageSender(id: "", name: "", role: "", userAgent: ""),
            let content = ContentPlainText(text: ""),
            let broker = BrokerMetaData(timestamp: "2017-05-19T03:39:31.814Z") else {
                XCTAssertNotNil(message)
                return
        }
        
        message = Message(id: "", conversationID: "", merchantID: "", channel: "", channelInfo: channelInfo, visitor: visitor, sender: sender, type: MessageType.PlainText, content: content, brokerMetaData: broker)
        
        if let message = message {
            PrismCore.shared.publishMessage(topic: "", message: message) { (response, error) in
                XCTAssertNil(error)
                XCTAssertNotNil(response)
            }
        } else {
            XCTAssertNotNil(message)
        }
    }
    
    func testPublishAttachmentMessage() {
        var message: Message?
        guard let channelInfo = MessageChannelInfo(id: "", name: ""),
            let visitor = MessageVisitorInfo(id: "", name: ""),
            let sender = MessageSender(id: "", name: "", role: "", userAgent: ""),
            let content = ContentAttachment(name: "", mimeType: "", url: "https://www.google.com", previewURL: "https://www.google.com"),
            let broker = BrokerMetaData(timestamp: "2017-05-19T03:39:31.814Z") else {
                XCTAssertNotNil(message)
                return
        }
        
        message = Message(id: "", conversationID: "", merchantID: "", channel: "", channelInfo: channelInfo, visitor: visitor, sender: sender, type: MessageType.Attachment, content: content, brokerMetaData: broker)
        
        if let message = message {
            PrismCore.shared.publishMessage(topic: "", message: message) { (response, error) in
                XCTAssertNil(error)
                XCTAssertNotNil(response)
            }
        } else {
            XCTAssertNotNil(message)
        }
    }
    
    func testPublishStickerMessage() {
        
        var message: Message?
        guard let channelInfo = MessageChannelInfo(id: "", name: ""),
            let visitor = MessageVisitorInfo(id: "", name: ""),
            let sender = MessageSender(id: "", name: "", role: "", userAgent: ""),
            let content = ContentSticker(name: "", imageURL: "https://www.google.com", id: "", packID: ""),
            let broker = BrokerMetaData(timestamp: "2017-05-19T03:39:31.814Z") else {
                XCTAssertNotNil(message)
                return
        }
        
        message = Message(id: "", conversationID: "", merchantID: "", channel: "", channelInfo: channelInfo, visitor: visitor, sender: sender, type: MessageType.Sticker, content: content, brokerMetaData: broker)
        
        if let message = message {
            PrismCore.shared.publishMessage(topic: "", message: message) { (response, error) in
                XCTAssertNil(error)
                XCTAssertNotNil(response)
            }
        } else {
            XCTAssertNotNil(message)
        }
    }
    
    func testPublishTypingStatusMessage() {
        
        var message: Message?
        guard let channelInfo = MessageChannelInfo(id: "", name: ""),
            let visitor = MessageVisitorInfo(id: "", name: ""),
            let sender = MessageSender(id: "", name: "", role: "", userAgent: ""),
            let content = ContentTyping(status: TypingStatus.StartTyping),
            let broker = BrokerMetaData(timestamp: "2017-05-19T03:39:31.814Z") else {
                XCTAssertNotNil(message)
                return
        }
        
        message = Message(id: "", conversationID: "", merchantID: "", channel: "", channelInfo: channelInfo, visitor: visitor, sender: sender, type: MessageType.Typing, content: content, brokerMetaData: broker)
        
        if let message = message {
            PrismCore.shared.publishMessage(topic: "", message: message) { (response, error) in
                XCTAssertNil(error)
                XCTAssertNotNil(response)
            }
        } else {
            XCTAssertNotNil(message)
        }
    }
    
    func testPublishOfflineMessage() {
        
        var message: Message?
        guard let channelInfo = MessageChannelInfo(id: "", name: ""),
            let visitor = MessageVisitorInfo(id: "", name: ""),
            let sender = MessageSender(id: "", name: "", role: "", userAgent: ""),
            let content = ContentOfflineMessage(name: "", email: "", phone: "", text: ""),
            let broker = BrokerMetaData(timestamp: "2017-05-19T03:39:31.814Z") else {
                XCTAssertNotNil(message)
                return
        }
        
        message = Message(id: "", conversationID: "", merchantID: "", channel: "", channelInfo: channelInfo, visitor: visitor, sender: sender, type: MessageType.OfflineMessage, content: content, brokerMetaData: broker)
        
        if let message = message {
            PrismCore.shared.publishMessage(topic: "", message: message) { (response, error) in
                XCTAssertNil(error)
                XCTAssertNotNil(response)
            }
        } else {
            XCTAssertNotNil(message)
        }
    }
}

class TestDelegate: PrismCoreDelegate {
    func didReceive(message data: Data, in topic: String) {

    }
}
