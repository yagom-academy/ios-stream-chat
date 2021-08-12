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
    }

    override func tearDownWithError() throws {
        self.chatManager = nil
    }

    func test_joinChat_채팅참가() {
        self.chatManager?.setNetwork()
        self.chatManager?.joinChat(username: "ksss")
        self.chatManager?.send(message: "되는거야??????")
        self.chatManager?.stopChatSession()
    }
    
}
