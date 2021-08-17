//
//  StreamChatTests.swift
//  StreamChatTests
//
//  Created by 최정민 on 2021/08/16.
//

import XCTest

@testable import StreamChat
class StreamChatTests: XCTestCase {
    var networkManager: NetworkManager!
    var expectation: XCTestExpectation!
    
    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let delegateQueue = OperationQueue.main
        networkManager = NetworkManager(configuration: configuration, delegateQueue: delegateQueue)
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_connectServer_성공() throws {

        guard let inputStream = networkManager.inputStream else {
            return
        }
        networkManager.stream(inputStream, handle: .hasBytesAvailable)
       
    }
}
