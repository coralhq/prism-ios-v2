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
}
