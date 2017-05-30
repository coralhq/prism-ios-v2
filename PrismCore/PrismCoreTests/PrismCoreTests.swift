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
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testVisitorConnect() {
        let endPoint = VisitorConnectEndPoint(visitorName: "asd", userID: "asd")
        NetworkMock.shared.request(endPoint: endPoint, mapToObject: ConnectResponse.self) { (response, error) in
            XCTAssertNil(error)
            XCTAssertNotNil(response)
        }
    }
}
