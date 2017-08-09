//
//  PrismUnitTests.swift
//  PrismUnitTests
//
//  Created by Nanang Rafsanjani on 6/15/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import XCTest
import PrismCore
import CoreData
@testable import PrismUI

class PrismUnitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAuthViewModel() {
        guard let connect = AuthViewModelMock().getConnectResponse(valid: true) else {
            XCTFail("connect response nil")
            return
        }
        
        guard let conversation = AuthViewModelMock().getCreateConversationResponse(valid: true) else {
            XCTFail("conversation response nil")
            return
        }
        
        let credential = PrismCredential()
        credential.configure(connect: connect, conversation: conversation)
        
        Settings.shared.configure(settings: AuthViewModelMock().getSetting())
        Vendor.shared.credential = credential
        
        XCTAssertNotNil(Vendor.shared.credential)
    }
    
    func testChatViewModel() {
        let coredata = CoreDataManager.shared
        
        guard let message = ChatViewModelMock().message else {
            XCTFail("cant create message mock")
            return
        }
        
        coredata.buildMessage(message: message)
        
        let cdMessage = CDMessage(with: coredata.mainContext, dictionary: message.dictionaryValue())
        
        
        guard let visitor = MessageSender(id: "", name: "", role: "", appName: "") else {
            XCTFail("cant create visitor mock")
            return
        }
        
        let viewModel = ChatViewModel(message: cdMessage, visitor: visitor)
        
        XCTAssertNotNil(viewModel)
    }
    
    func testStickerViewModel() {
        guard let sticker = StickerViewModelMock().sticker else {
            XCTFail("cant create visitor mock")
            return
        }
        
        let viewModel = StickerViewModel(sticker: sticker)
        XCTAssertNotNil(viewModel)
    }
    
    func testStickerPackViewModel() {
        guard let stickerPack = StickerPackViewModelMock().stickerPack else {
            XCTFail("cant create visitor mock")
            return
        }
        
        let viewModel = StickerPackViewModel(pack: stickerPack)
        XCTAssertNotNil(viewModel)
    }
    
    func testContentMessagesViewModel() {
        let textDict = ContentMock().text()
        let contentText = CDContentPlainText(dictionary: textDict)
        let text = ContentTextViewModel(contentText: contentText!)
        XCTAssertNotNil(contentText?.dictionaryValue())
        XCTAssertNotNil(text)
        
        let stickerDict: [String: Any] = ContentMock().sticker()
        let contentSticker =  CDContentSticker(dictionary: stickerDict)
        let sticker = ContentStickerViewModel(contentSticker: contentSticker!)
        XCTAssertNotNil(contentSticker?.dictionaryValue())
        XCTAssertNotNil(sticker)
        
        let invoiceDict: [String: Any] = ContentMock().invoice()
        let contentInvoice = CDContentInvoice(dictionary: invoiceDict)
        let invoice = ContentInvoiceViewModel(contentInvoice: contentInvoice!)
        XCTAssertNotNil(contentInvoice?.dictionaryValue())
        XCTAssertNotNil(invoice)
        
        let cartDict: [String: Any] = ContentMock().cart()
        let contentCart = CDContentCart(dictionary: cartDict)
        let cart = ContentCartViewModel(contentCart: contentCart!)
        XCTAssertNotNil(contentCart?.dictionaryValue())
        XCTAssertNotNil(cart)
        
        let productDict: [String: Any] = ContentMock().product()
        let contentProduct = CDContentProduct(dictionary: productDict)
        let product = ContentProductViewModel(contentProduct: contentProduct!)
        XCTAssertNotNil(contentProduct?.dictionaryValue())
        XCTAssertNotNil(product)
        
        let attDict: [String: Any] = ContentMock().attachment()
        let contentAtt = CDContentAttachment(dictionary: attDict)
        let att = ContentImageViewModel(contentImage: contentAtt!)
        XCTAssertNotNil(contentAtt?.dictionaryValue())
        XCTAssertNotNil(att)
        
        let offDict: [String: Any] = ContentMock().offline()
        let contentOff = CDContentOfflineMessage(dictionary: offDict)
        let off = ContentOfflineViewModel(contentOfflineMessage: contentOff!)
        XCTAssertNotNil(contentOff?.dictionaryValue())
        XCTAssertNotNil(off)
        
        let closeDict: [String: Any] = ContentMock().close()
        let contentClose = CDContentCloseChat(dictionary: closeDict)
        let close = ContentCloseChatViewModel(contentText: contentClose!)
        XCTAssertNotNil(contentClose?.dictionaryValue())
        XCTAssertNotNil(close)
    }
}
