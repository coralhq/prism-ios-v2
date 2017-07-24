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
    
    var locToSave = ""
    
    override func setUp() {
        super.setUp()
        
        let path = NSTemporaryDirectory() as NSString
        locToSave = path.appendingPathComponent("teststasks")
        
        Config.shared.configure(environment: .Sandbox, merchantID: "")
        PrismCore.shared.network = NetworkMock.shared
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testConfigure() {
        
        PrismCore.shared.configure(environment: .Production, merchantID: "")
        XCTAssertTrue(URL.getSettings.absoluteString.contains("api.prismapp.io"))
        
        PrismCore.shared.configure(environment: .Sandbox, merchantID: "")
        XCTAssertTrue(URL.getSettings.absoluteString.contains("prismapp.io"))
        
        XCTAssertNotNil(Config.shared.getEnvironment())
        XCTAssertNotNil(Config.shared.getMerchantID())
        
        let session = MQTTSession(host: "", port: 12, clientID: "", cleanSession: true, keepAlive: 20)
        PrismCore.shared.mqttDidDisconnect(session: session)
        PrismCore.shared.mqttDidReceive(message: Data(), in: "", from: session)
        PrismCore.shared.mqttSocketErrorOccurred(session: session)
    }
    
    func testPublishMessageEndPoint() {
        let content = ContentAttachment(name: "", mimeType: "", url: "https://www.google.com", previewURL: "https://www.google.com")
        
        guard let channelInfo = MessageChannelInfo(id: "", name: ""),
            let visitor = MessageVisitorInfo(id: "", name: ""),
            let sender = MessageSender(id: "", name: "", role: "", userAgent: ""),
            let broker = BrokerMetaData(dictionary: ["timestamp": "2017-05-19T03:39:31.814Z"]) else {
                return
        }
        
        let message = Message(id: "", conversationID: "", merchantID: "", channel: "", visitor: visitor, sender: sender, type: MessageType.Attachment, content: content, brokerMetaData: broker, channelInfo: channelInfo)
        
        let endPoint = PublishMessageEndPoint(token: "", messages: [message], topic: "")
        
        XCTAssertNotNil(endPoint.httpBody)
        XCTAssertNotNil(endPoint.messagesBody)
        XCTAssertNotNil(endPoint.contentType)
        XCTAssertNotNil(endPoint.contentType)
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
        
        PrismCore.shared.visitorConnect(userName: "asdasdasd", userID: "asdasd") { (response, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            XCTAssertNotNil(response?.dictionaryValue())
        }
    }
    
    func testInvalidVisitorConnect() {
        
        TestConfig.shared.isValidResponse = false
        PrismCore.shared.visitorConnect(userName: "asdasdasd", userID: "asdasd") { (response, error) in
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
            XCTAssertNotNil(response?.packs[0].dictionaryValue())
            XCTAssertNotNil(response?.packs)
            XCTAssertNotNil(response?.dictionaryValue())
            self.keyedArchiveTester(data: response!)
            self.keyedArchiveTester(data: (response!).packs[0])
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
        XCTAssertNotNil(BrokerMetaData())
        
        TestConfig.shared.isValidResponse = true
        
        PrismCore.shared.createConversation(visitorName: "", token: "") { (response, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
            XCTAssertNotNil(response?.dictionaryValue())
            XCTAssertNotNil(response?.conversation.dictionaryValue())
        }
    }
    
    func testPublishPlainTextMessage() {
        
        var messageObject: Message?
        let invalidDictionary: [String: Any] = [
            "wrong": 0
        ]
        
        let invalidVisitorInfo = MessageVisitorInfo(dictionary: invalidDictionary)
        let invalidSender = MessageSender(dictionary: invalidDictionary)
        let invalidBroker = BrokerMetaData(dictionary: ["timestamp": ""])
        
        guard let channelInfo = MessageChannelInfo(id: "", name: ""),
            let visitor = MessageVisitorInfo(id: "", name: ""),
            let sender = MessageSender(id: "", name: "", role: "", userAgent: ""),
            let content = ContentPlainText(text: ""),
            let broker = BrokerMetaData(dictionary: ["timestamp": "2017-05-19T03:39:31.814Z"]) else {
                XCTAssertNotNil(messageObject)
                return
        }
        
        
        if let visitor = invalidVisitorInfo,
            let sender = invalidSender,
            let broker = invalidBroker {
            
            let message = Message(id: "", conversationID: "", merchantID: "", channel: "", visitor: visitor, sender: sender, type: MessageType.PlainText, content: content, brokerMetaData: broker, channelInfo: channelInfo)
            
            messageObject = message
            
            XCTFail("\(String(describing: messageObject)) should be nil")
        } else {
            
        let message = Message(id: "", conversationID: "", merchantID: "", channel: "", visitor: visitor, sender: sender, type: MessageType.PlainText, content: content, brokerMetaData: broker, channelInfo: channelInfo)
            
            messageObject = message
            PrismCore.shared.publishMessage(token: "", topic: "", messages: [messageObject!]) { (response, error) in
                XCTAssertNotNil(response)
                XCTAssertNotNil(response?.dictionaryValue())
            }
        }
    }
    
    func testPublishAttachmentMessage() {
        var message: Message?
        
        let content = ContentAttachment(name: "", mimeType: "", url: "https://www.google.com", previewURL: "https://www.google.com")
        
        guard let channelInfo = MessageChannelInfo(id: "", name: ""),
            let visitor = MessageVisitorInfo(id: "", name: ""),
            let sender = MessageSender(id: "", name: "", role: "", userAgent: ""),
            let broker = BrokerMetaData(dictionary: ["timestamp": "2017-05-19T03:39:31.814Z"]) else {
                XCTAssertNotNil(message)
                return
        }
        
        message = Message(id: "", conversationID: "", merchantID: "", channel: "", visitor: visitor, sender: sender, type: MessageType.Attachment, content: content, brokerMetaData: broker, channelInfo: channelInfo)
        
        let contentWithoutPreviewURL = ContentAttachment(name: "", mimeType: "", url: "https://www.google.com")
        
        let _ = Message(id: "", conversationID: "", merchantID: "", channel: "", visitor: visitor, sender: sender, type: MessageType.Attachment, content: contentWithoutPreviewURL, brokerMetaData: broker, channelInfo: channelInfo)
        
        if let message = message {
            PrismCore.shared.publishMessage(token: "", topic: "", messages: [message]) { (response, error) in
                XCTAssertNotNil(response)
            }
        } else {
            XCTAssertNotNil(message)
        }
    }
    
    private func keyedArchiveTester(data: NSCoding) {
        NSKeyedArchiver.archiveRootObject([data], toFile: locToSave)
        let unarchived = NSKeyedUnarchiver.unarchiveObject(withFile: locToSave)
        XCTAssertNotNil(unarchived)
    }
    
    func testPublishStickerMessage() {
        
        var message: Message?
        guard let channelInfo = MessageChannelInfo(id: "", name: ""),
            let visitor = MessageVisitorInfo(id: "", name: ""),
            let sender = MessageSender(id: "", name: "", role: "", userAgent: ""),
            let content = ContentSticker(name: "", imageURL: "https://www.google.com", id: "", packID: ""),
            let broker = BrokerMetaData(dictionary: ["timestamp": "2017-05-19T03:39:31.814Z"]) else {
                
                XCTAssertNotNil(message)
                return
        }
        
        XCTAssertNotNil(content.dictionaryValue())
        XCTAssertNotNil(content.sticker.dictionaryValue())
        
        message = Message(id: "", conversationID: "", merchantID: "", channel: "", visitor: visitor, sender: sender, type: MessageType.Sticker, content: content, brokerMetaData: broker, channelInfo: channelInfo)
        
        if let message = message {
            PrismCore.shared.publishMessage(token: "", topic: "", messages: [message]) { (response, error) in
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
            let broker = BrokerMetaData(dictionary: ["timestamp": "2017-05-19T03:39:31.814Z"]) else {
                XCTAssertNotNil(message)
                return
        }
        
        XCTAssertNotNil(content.dictionaryValue())
        
        message = Message(id: "", conversationID: "", merchantID: "", channel: "", visitor: visitor, sender: sender, type: MessageType.Typing, content: content, brokerMetaData: broker, channelInfo: channelInfo)
        
        if let message = message {
            PrismCore.shared.publishMessage(token: "", topic: "", messages: [message]) { (response, error) in
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
            let broker = BrokerMetaData(dictionary: ["timestamp": "2017-05-19T03:39:31.814Z"]) else {
                XCTAssertNotNil(message)
                return
        }
        
        XCTAssertNotNil(content.dictionaryValue())
        
        message = Message(id: "", conversationID: "", merchantID: "", channel: "", visitor: visitor, sender: sender, type: MessageType.OfflineMessage, content: content, brokerMetaData: broker, channelInfo: channelInfo)
        
        let altChannelInfo = MessageChannelInfo(id: "", name: "", attribute: ["":0])
        XCTAssertNotNil(altChannelInfo?.dictionaryValue())
        XCTAssertNotNil(channelInfo.dictionaryValue())
        XCTAssertNil(MessageChannelInfo(dictionary: ["id": 0]))
        
        if let message = message {
            PrismCore.shared.publishMessage(token: "", topic: "", messages: [message]) { (response, error) in
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
        
        let endPoint = GetConversationHistoryEndPoint(conversationID: conversationID, token: token, startTime: 0, endTime: 10)
        XCTAssertNotNil(endPoint.token)
        XCTAssertNotNil(endPoint.contentType)
        XCTAssertNotNil(endPoint.httpBody)
        XCTAssert(endPoint.url == URL.getConversationHistory(conversationID: conversationID, startTime: 0, endTime: 10))
        
        TestConfig.shared.isValidResponse = true
        
        PrismCore.shared.getConversationHistory(conversationID: "", token: "", startTime: 0, endTime: 10) { (response, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(response?.dictionaryValue())
        }
    }
    
    func testInvalidGetConversationHistory() {
        
        let invalidConversation = Conversation(dictionary: [ : ])
        XCTAssertNil(invalidConversation)
        
        let invalidConversationMassage = ConversationHistory(dictionary: JSONResponseMock.getConversationHistoryResponseInvalidMessage)
        XCTAssertNotNil(invalidConversationMassage)
        
        TestConfig.shared.isValidResponse = false
        PrismCore.shared.getConversationHistory(conversationID: "", token: "", startTime: 0, endTime: 10) { (response, error) in
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
            XCTAssertNotNil(response?.dictionaryValue())
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
        
        let cAssg = ContentAssignment(dictionary: assignmentObject)
        XCTAssertNotNil(cAssg?.dictionaryValue())
        
        let cARes = ContentAutoResponder(dictionary: autoresponderObject)
        XCTAssertNotNil(cARes?.dictionaryValue())
        
        let cCart = ContentCart(dictionary: cartObject)
        XCTAssertNotNil(cCart?.dictionaryValue())
        
        let cCCHat = ContentCloseChat(dictionary: closeChatObject)
        XCTAssertNotNil(cCCHat?.dictionaryValue())
        
        let cInv = ContentInvoice(dictionary: invoiceObject)
        XCTAssertNotNil(cInv?.dictionaryValue())
        XCTAssertNotNil(cInv?.payment.dictionaryValue())
        
        let cPro = ContentProduct(dictionary: productObject)
        XCTAssertNotNil(cPro?.dictionaryValue())
        
        let cStUp = ContentStatusUpdate(dictionary: statusUpdateObject)
        XCTAssertNotNil(cStUp?.dictionaryValue())
    }
    
    func testInvalidMessageContentCreation() {
        XCTAssertNil(ContentAssignment(dictionary: ["":0]))
        XCTAssertNil(ContentAutoResponder(dictionary: ["":0]))
        XCTAssertNil(ContentCart(dictionary: ["":0]))
        XCTAssertNil(ContentCloseChat(dictionary: ["":0]))
        XCTAssertNil(ContentInvoice(dictionary: ["":0]))
        XCTAssertNil(ContentProduct(dictionary: ["":0]))
        XCTAssertNil(ContentStatusUpdate(dictionary: ["":0]))
        XCTAssertNil(ContentAttachment(dictionary: ["":0]))
        XCTAssertNil(LineItem(dictionary: ["":0]))
        XCTAssertNil(Discount(dictionary: ["":0]))
        XCTAssertNil(Payment(dictionary: ["":0]))
        XCTAssertNil(Shipment(dictionary: ["":0]))
        XCTAssertNil(ShipmentInfo(dictionary: ["":0]))
        XCTAssertNil(Buyer(dictionary: ["":0]))
        XCTAssertNil(Currency(dictionary: ["":0]))
        XCTAssertNil(ContentOfflineMessage(dictionary: ["":0]))
        XCTAssertNil(ContentPlainText(dictionary: ["":0]))
        XCTAssertNil(ContentSticker(dictionary: ["":0]))
        XCTAssertNil(MessageSticker(dictionary: ["":0]))
        XCTAssertNil(ContentTyping(dictionary: ["":0]))
        XCTAssertNil(TypingStatus(rawValue:""))
        
        XCTAssertNil(ContentCart(dictionary: Utils.jsonObject(from: "invalidCart") as? [String: Any]))
        XCTAssertNil(ContentInvoice(dictionary: Utils.jsonObject(from: "invalidInvoice") as? [String: Any]))
        XCTAssertNil(Product(dictionary: Utils.jsonObject(from: "invalidProduct") as? [String: Any]))
        
        XCTAssert(MessageType(rawValue: "auto_responder") == MessageType.AutoResponder)
        XCTAssert(MessageType(rawValue: "assignment") == MessageType.Assignment)
        XCTAssert(MessageType(rawValue: "cart") == MessageType.Cart)
        XCTAssert(MessageType(rawValue: "close_chat") == MessageType.CloseChat)
        XCTAssert(MessageType(rawValue: "invoice") == MessageType.Invoice)
        XCTAssert(MessageType(rawValue: "product") == MessageType.Product)
        XCTAssert(MessageType(rawValue: "message_status_update") == MessageType.StatusUpdate)
        
        XCTAssert("auto_responder" == MessageType.AutoResponder.rawValue)
        XCTAssert("assignment" == MessageType.Assignment.rawValue)
        XCTAssert("cart" == MessageType.Cart.rawValue)
        XCTAssert("close_chat" == MessageType.CloseChat.rawValue)
        XCTAssert("invoice" == MessageType.Invoice.rawValue)
        XCTAssert("product" == MessageType.Product.rawValue)
        XCTAssert("message_status_update" == MessageType.StatusUpdate.rawValue)
        
        XCTAssert(TypingStatus(rawValue: "start_typing") == TypingStatus.StartTyping)
        XCTAssert(TypingStatus(rawValue: "end_typing") == TypingStatus.EndTyping)
        XCTAssert(TypingStatus.EndTyping.rawValue == "end_typing")
    }
}

class TestDelegate: PrismCoreDelegate {
    func didReceive(message data: Data, in topic: String) {
        
    }
}
