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
        PrismCore.shared.annonymousVisitorConnect() { (response, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
        }
    }
  
    func testGetStickers() {
        PrismCore.shared.getStickers(token: "") { (response, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
        }
    }
    
    func testConnectToBroker() {
        PrismCore.shared.connectToBroker(username: JSONResponseMock.mqttUsername, password: JSONResponseMock.mqttPassword) { (connected, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(connected)
        }
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
    
    func testSubscribeToTopic() {
        PrismCore.shared.subscribeToTopic(JSONResponseMock.mqttTopic) { (success, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(success)
        }
    }
    
    func testGetConversationHistory() {
        PrismCore.shared.getConversationHistory(conversationID: "", token: "") { (response, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
        }
    }

    func testUnsubscribeFromTopic() {
        PrismCore.shared.unsubscribeFromTopic(topic: "") { (success, error) in
            XCTAssertTrue(success)
        }
    }
    
    func testRefreshToken() {
        PrismCore.shared.refreshToken(clientID: "", refreshToken: "") { (response, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
        }
    }
    
    func testDisconnectFromBroker() {
        PrismCore.shared.disconnectFromBroker { response in
            XCTAssertTrue(response)
        }
    }
}

class TestDelegate: PrismCoreDelegate {
    func didReceive(message data: Data, in topic: String) {
        
    }
}
