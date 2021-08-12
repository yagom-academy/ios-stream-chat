//
//  StreamChatTests.swift
//  StreamChatTests
//
//  Created by Fezravien on 2021/08/12.
//

import XCTest
@testable import StreamChat

class StreamChatTests: XCTestCase {
    var chatManager: ChatManager?
    override func setUpWithError() throws {
        self.chatManager = ChatManager()
        self.chatManager?.setNetwork()
    }

    override func tearDownWithError() throws {
        self.chatManager = nil
    }

    func test_joinChat_채팅참가() {
        self.chatManager?.joinChat(username: "Fezz")
        self.chatManager?.send(message: "지금 PR 보내려고 합니다 !!")
        self.chatManager?.stopChatSession()
    }
    
    func test_sendChat_채팅보내기() {
        
    }
    
    func test_deConnect_채팅나감() {
        
    }
}
