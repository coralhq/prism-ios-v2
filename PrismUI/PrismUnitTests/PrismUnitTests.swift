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
        
        XCTAssertNotNil(cdMessage.dictionaryValue())
        XCTAssertNotNil(viewModel)
    }
    
    func testStickerViewModel() {
        guard let sticker = StickerViewModelMock().sticker else {
            XCTFail("cant create visitor mock")
            return
        }
        
        let viewModel = StickerViewModel(sticker: sticker)
        XCTAssertNotNil(viewModel)
        Decoder(object: viewModel)
    }
    
    func testStickerPackViewModel() {
        guard let stickerPack = StickerPackViewModelMock().stickerPack else {
            XCTFail("cant create visitor mock")
            return
        }
        
        let viewModel = StickerPackViewModel(pack: stickerPack)
        XCTAssertNotNil(viewModel)
        Decoder(object: viewModel)
    }
    
    func testContentMessagesViewModel() {
        let textDict = ContentMock().text()
        let contentText = CDContentPlainText(dictionary: textDict)
        let text = ContentTextViewModel(contentText: contentText!)
        Decoder(object: contentText)
        XCTAssertNotNil(contentText?.dictionaryValue())
        XCTAssertNotNil(text)
        
        let stickerDict: [String: Any] = ContentMock().sticker()
        let contentSticker =  CDContentSticker(dictionary: stickerDict)
        let sticker = ContentStickerViewModel(contentSticker: contentSticker!)
        Decoder(object: contentSticker)
        XCTAssertNotNil(contentSticker?.dictionaryValue())
        XCTAssertNotNil(sticker)
        
        let invoiceDict: [String: Any] = ContentMock().invoice()
        let contentInvoice = CDContentInvoice(dictionary: invoiceDict)
        let invoice = ContentInvoiceViewModel(contentInvoice: contentInvoice!)
        Decoder(object: contentInvoice)
        XCTAssertNotNil(contentInvoice?.dictionaryValue())
        XCTAssertNotNil(invoice)
        
        let cartDict: [String: Any] = ContentMock().cart()
        let contentCart = CDContentCart(dictionary: cartDict)
        let cart = ContentCartViewModel(contentCart: contentCart!)
        Decoder(object: contentCart)
        XCTAssertNotNil(contentCart?.dictionaryValue())
        XCTAssertNotNil(cart)
        
        let productDict: [String: Any] = ContentMock().product()
        let contentProduct = CDContentProduct(dictionary: productDict)
        let product = ContentProductViewModel(contentProduct: contentProduct!)
        Decoder(object: contentProduct)
        XCTAssertNotNil(contentProduct?.dictionaryValue())
        XCTAssertNotNil(product)
        
        let attDict: [String: Any] = ContentMock().attachment()
        let contentAtt = CDContentAttachment(dictionary: attDict)
        let att = ContentImageViewModel(contentImage: contentAtt!)
        Decoder(object: contentAtt)
        XCTAssertNotNil(contentAtt?.dictionaryValue())
        XCTAssertNotNil(att)
        
        let offDict: [String: Any] = ContentMock().offline()
        let contentOff = CDContentOfflineMessage(dictionary: offDict)
        let off = ContentOfflineViewModel(contentOfflineMessage: contentOff!)
        Decoder(object: contentOff)
        XCTAssertNotNil(contentOff?.dictionaryValue())
        XCTAssertNotNil(off)
        
        let closeDict: [String: Any] = ContentMock().close()
        let contentClose = CDContentCloseChat(dictionary: closeDict)
        let close = ContentCloseChatViewModel(contentText: contentClose!)
        Decoder(object: contentClose)
        XCTAssertNotNil(contentClose?.dictionaryValue())
        XCTAssertNotNil(close)
        
        let dict: [String: Any] = [
            "redirect_url": "https://www.f.com"
        ]
        let cdMidtransInfo = CDMidtransInfo(dictionary: dict)
        Decoder(object: cdMidtransInfo)
        XCTAssertNotNil(cdMidtransInfo)
        XCTAssertNotNil(cdMidtransInfo?.dictionaryValue())
        
        let dictBank: [String: Any] = [
            "account_holder": "https://www.f.com",
            "account_number": "",
            "bank_name": ""
        ]
        let bankInfo = CDBankTransferInfo(dictionary: dictBank)
        Decoder(object: bankInfo)
        XCTAssertNotNil(bankInfo)
        XCTAssertNotNil(bankInfo?.dictionaryValue())
        
    }
    
    func testTheme() {
        let theme = Theme()
        
        theme.configure(option: .AzureWhite)
        XCTAssertTrue(theme.buttonColor == UIColor.steelBlue)
        
        theme.configure(option: .BananaTokyo)
        XCTAssertTrue(theme.buttonColor == UIColor.yellowOrange)
        
        theme.configure(option: .CitrusLime)
        XCTAssertTrue(theme.buttonColor == UIColor.coolGreen)
        
        theme.configure(option: .CoralReef)
        XCTAssertTrue(theme.buttonColor == UIColor.tomato)
        
        theme.configure(option: .JetBlack)
        XCTAssertTrue(theme.buttonColor == UIColor.jetBlack)
        
        theme.configure(option: .PinkScarlet)
        XCTAssertTrue(theme.buttonColor == UIColor.fadedRed)
        
    }
    
    private func Decoder<T>(object: T) {
        
        let path = NSTemporaryDirectory() as NSString
        let locToSave = path.appendingPathComponent("teststasks")
        
        let newObject = object
        
        // save tasks
        NSKeyedArchiver.archiveRootObject([newObject], toFile: locToSave)
        
        // load tasks
        let data = NSKeyedUnarchiver.unarchiveObject(withFile: locToSave)
        
        XCTAssertNotNil(data)
    }
}
