//
//  StreamChatTests.swift
//  StreamChatTests
//
//  Created by 황인우 on 2021/08/13.
//
@testable import StreamChat
import XCTest

class StreamChatTests: XCTestCase {
    var sut_chatroom: ChatRoom!
    var mock_networkmanager: ChatNetworkManager!
    var mock_urlsession: URLSessionProtocol!
    var mock_streamtask: MockStreamTask!
    
    override func setUpWithError() throws {
        
        // given
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        mock_urlsession = MockURLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        mock_networkmanager = ChatNetworkManager(urlSession: mock_urlsession)
        mock_streamtask = MockStreamTask()
        mock_networkmanager.streamTask = mock_streamtask
        sut_chatroom = ChatRoom(chatNetworkManager: mock_networkmanager)
        
    }

    override func tearDownWithError() throws {
        mock_urlsession = nil
    }
    
    func test_sut_chatroom_에서_joinChat메서드_호출시_streamtask가_정상적으로_writeData를_할수있는지_체크() {
        
        // given
        let expectation = XCTestExpectation()
        let name = "James"
        
        
        // when
        mock_streamtask.resultHandler = {
            let expectedString = String(data: self.mock_streamtask.dataList.first!, encoding: .utf8)!
            
            // then
            // verify that mock streamtask was able to write data and add it to expected array
            XCTAssertEqual(self.mock_streamtask.dataList.count, 1)
            
            // verify that the written data is an expected data
            XCTAssertEqual(expectedString, "James123")
            
            // verify that write method was called only once
            XCTAssertEqual(self.mock_streamtask.writeCounter, 1)
            expectation.fulfill()
        }
        sut_chatroom.joinChat(username: name)
        wait(for: [expectation], timeout: 3)
    }
}
