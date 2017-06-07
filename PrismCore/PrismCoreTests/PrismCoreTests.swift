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

        let visitorName = "visitor_name"
        let userID = "user_id"
        let endPoint = VisitorConnectEndPoint(visitorName: visitorName, userID: userID)
        
        XCTAssertEqual(endPoint.httpBody["name"] as? String, visitorName)
        XCTAssertEqual(endPoint.httpBody["channel_user_id"] as? String, userID)
        XCTAssertNotNil(endPoint.contentType)
        XCTAssertNotNil(endPoint.httpBody)
        
        TestConfig.shared.isValidResponse = true

        PrismCore.shared.visitorConnect(visitorName: "asdasdasd", userID: "asdasd") { (response, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
        }
    }
    
    func testInvalidVisitorConnect() {
        
        TestConfig.shared.isValidResponse = false
        PrismCore.shared.visitorConnect(visitorName: "asdasdasd", userID: "asdasd") { (response, error) in
            XCTAssertNil(response)
            XCTAssertNotNil(error)
        }
    }
    
    func testAnnonymousVisitorConnect() {
        
        TestConfig.shared.isValidResponse = true
        PrismCore.shared.annonymousVisitorConnect() { (response, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
        }
    }
    
    func testInvalidAnnonymousVisitorConnect() {
        
        TestConfig.shared.isValidResponse = false
        PrismCore.shared.annonymousVisitorConnect() { (response, error) in
            XCTAssertNil(response)
            XCTAssertNotNil(error)
        }
    }
    
    func testGetStickers() {
        let endPoint = GetStickersEndPoint(token: "token")
        XCTAssertNotNil(endPoint.token)
        XCTAssertNotNil(endPoint.contentType)
        XCTAssertNotNil(endPoint.httpBody)
        
        TestConfig.shared.isValidResponse = true
        PrismCore.shared.getStickers(token: "") { (response, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
        }
    }
    
    func testInvalidGetStickers() {
        
        let invalidSticker = StickerResponse(dictionary: [:])
        XCTAssertNil(invalidSticker)
        
        TestConfig.shared.isValidResponse = false
        PrismCore.shared.getStickers(token: "") { (response, error) in
            XCTAssertNil(response)
            XCTAssertNotNil(error)
        }
    }
    
    func testConnectToBroker() {
        PrismCore.shared.connectToBroker(username: JSONResponseMock.mqttUsername, password: JSONResponseMock.mqttPassword) { (connected, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(connected)
        }
    }
    
    func testGetSettings() {
        let endPoint = GetSettingsEndPoint()
        XCTAssertNotNil(endPoint.contentType)
        XCTAssertNotNil(endPoint.httpBody)
        

        
        TestConfig.shared.isValidResponse = true

        PrismCore.shared.getSettings() { (response, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
        }
    }
    
    func testInvalidGetSettings() {
        
        TestConfig.shared.isValidResponse = false
        PrismCore.shared.getSettings() { (response, error) in
            XCTAssertNil(response)
            XCTAssertNotNil(error)
        }
    }
    
    func testGetAttachmentURL() {
        let filename = "filename"
        let conversationID = "conversation_id"
        let token = "token"
        
        let endPoint = GetAttachmentURLEndPoint(filename: filename, conversationID: conversationID, token: token)
        XCTAssertNotNil(endPoint.token)
        XCTAssertEqual(endPoint.httpBody["filename"] as! String, filename)
        XCTAssertNotNil(endPoint.contentType)
        XCTAssertNotNil(endPoint.httpBody)
        XCTAssert(endPoint.url == URL.getAttachmentURL(conversationID: conversationID))
        
        TestConfig.shared.isValidResponse = true
        PrismCore.shared.getAttachmentURL(filename: "", conversationID: "", token: "") { (response, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
        }
    }
    
    func testInvalidGetAttachmentURL() {
        
        TestConfig.shared.isValidResponse = false
        PrismCore.shared.getAttachmentURL(filename: "", conversationID: "", token: "") { (response, error) in
            XCTAssertNil(response)
            XCTAssertNotNil(error)
        }
    }
    
    func testCreateConversation() {
        let visitorName = "visitor name"
        let token = "token"
        
        let endPoint = CreateConversationEndPoint(visitorName: visitorName, token: token)
        XCTAssertEqual(endPoint.visitorName, visitorName)
        XCTAssertNotNil(token)
        XCTAssertNotNil(endPoint.contentType)
        XCTAssertNotNil(endPoint.httpBody)
        
        TestConfig.shared.isValidResponse = true

        PrismCore.shared.createConversation(visitorName: "", token: "") { (response, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
        }
    }
    
    func testPublishPlainTextMessage() {

        var messageObject: Message?
        let invalidDictionary: [String: Any] = [
            "wrong": 0
        ]
        
        let invalidVisitorInfo = MessageVisitorInfo(dictionary: invalidDictionary)
        let invalidSender = MessageSender(dictionary: invalidDictionary)
        let invalidBroker = BrokerMetaData(timestamp: "")
        
        guard let channelInfo = MessageChannelInfo(id: "", name: ""),
            let visitor = MessageVisitorInfo(id: "", name: ""),
            let sender = MessageSender(id: "", name: "", role: "", userAgent: ""),
            let content = ContentPlainText(text: ""),
            let broker = BrokerMetaData(timestamp: "2017-05-19T03:39:31.814Z") else {
                XCTAssertNotNil(messageObject)
                return
        }
        
        
        if let visitor = invalidVisitorInfo,
            let sender = invalidSender,
            let broker = invalidBroker,
            let message = Message(id: "", conversationID: "", merchantID: "", channel: "", channelInfo: channelInfo, visitor: visitor, sender: sender, type: MessageType.PlainText, content: content, brokerMetaData: broker) {
            messageObject = message
            
            XCTFail("\(String(describing: messageObject)) should be nil")
        } else if let message = Message(id: "", conversationID: "", merchantID: "", channel: "", channelInfo: channelInfo, visitor: visitor, sender: sender, type: MessageType.PlainText, content: content, brokerMetaData: broker) {
            
            messageObject = message
            PrismCore.shared.publishMessage(topic: "", message: messageObject!) { (response, error) in
                XCTAssertNil(error)
                XCTAssertNotNil(response)
            }
        } else {
            XCTAssertNotNil(messageObject)
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
  
    func testInvalidCreateConversation() {
        
        TestConfig.shared.isValidResponse = false
        
        PrismCore.shared.createConversation(visitorName: "", token: "") { (response, error) in
            XCTAssertNil(response)
            XCTAssertNotNil(error)
        }
    }
    
    func testUploadAttachment() {
        guard let data = UIImagePNGRepresentation(JSONResponseMock.attachmentImage) else { return }
        PrismCore.shared.uploadAttachment(with: data, url: JSONResponseMock.attachmentURL) { (success, error) in
            XCTAssert(success)
        }
    }
    
    func testSubscribeToTopic() {
        PrismCore.shared.subscribeToTopic(JSONResponseMock.mqttTopic) { (success, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(success)
        }
    }
    
    func testGetConversationHistory() {

        let conversationID = "conversation_id"
        let token = "token"
        
        let endPoint = GetConversationHistoryEndPoint(conversationID: conversationID, token: token)
        XCTAssertNotNil(endPoint.token)
        XCTAssertNotNil(endPoint.contentType)
        XCTAssertNotNil(endPoint.httpBody)
        XCTAssert(endPoint.url == URL.getConversationHistory(conversationID: conversationID))
        
            TestConfig.shared.isValidResponse = true

        PrismCore.shared.getConversationHistory(conversationID: "", token: "") { (response, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
        }
    }
    
    func testInvalidGetConversationHistory() {
        
        let invalidConversation = Conversation(dictionary: [ : ])
        XCTAssertNil(invalidConversation)
        
        let invalidConversationMassage = ConversationHistory(dictionary: JSONResponseMock.getConversationHistoryResponseInvalidMessage)
        XCTAssertNil(invalidConversationMassage)
        
        TestConfig.shared.isValidResponse = false
        PrismCore.shared.getConversationHistory(conversationID: "", token: "") { (response, error) in
            XCTAssertNil(response)
            XCTAssertNotNil(error)
        }
    }
    
    func testUnsubscribeFromTopic() {
        PrismCore.shared.unsubscribeFromTopic(topic: "") { (success, error) in
            XCTAssertTrue(success)
        }
    }
    
    func testRefreshToken() {

        let clientID = "client id"
        let refreshToken = "refresh token"
        let endPoint = RefreshTokenEndPoint(clientID: clientID, refreshToken: refreshToken)
        
        XCTAssertEqual(endPoint.httpBody["client_id"] as! String, clientID)
        XCTAssertEqual(endPoint.httpBody["refresh_token"] as! String, refreshToken)
        XCTAssertNotNil(endPoint.contentType)
        XCTAssertNotNil(endPoint.httpBody)
        
        TestConfig.shared.isValidResponse = true

        PrismCore.shared.refreshToken(clientID: "", refreshToken: "") { (response, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
        }
    }
    
    func testInvalidRefreshToken() {
        
        TestConfig.shared.isValidResponse = false
        PrismCore.shared.refreshToken(clientID: "", refreshToken: "") { (response, error) in
            XCTAssertNil(response)
            XCTAssertNotNil(error)
        }
    }
    
    func testDisconnectFromBroker() {
        PrismCore.shared.disconnectFromBroker { response in
            XCTAssertTrue(response)
        }
    }
    
    func testMessageContentCreation() {
        guard let assignmentObject = Utils.jsonObject(from: "assignment") as? [String: Any],
            let autoresponderObject = Utils.jsonObject(from: "autoResponder") as? [String: Any],
            let cartObject = Utils.jsonObject(from: "cart") as? [String: Any],
            let closeChatObject = Utils.jsonObject(from: "closeChat") as? [String: Any],
            let invoiceObject = Utils.jsonObject(from: "invoice") as? [String: Any],
            let productObject = Utils.jsonObject(from: "product") as? [String: Any],
            let statusUpdateObject = Utils.jsonObject(from: "statusUpdate") as? [String: Any] else {
                XCTFail()
                return
        }
        let _ = ContentAssignment(dictionary: assignmentObject)
        let _ = ContentAutoResponder(dictionary: autoresponderObject)
        let _ = ContentCart(dictionary: cartObject)
        let _ = ContentCloseChat(dictionary: closeChatObject)
        let _ = ContentInvoice(dictionary: invoiceObject)
        let _ = ContentProduct(dictionary: productObject)
        let _ = ContentStatusUpdate(dictionary: statusUpdateObject)
    }
}

class TestDelegate: PrismCoreDelegate {
    func didReceive(message data: Data, in topic: String) {
        
    }
}
