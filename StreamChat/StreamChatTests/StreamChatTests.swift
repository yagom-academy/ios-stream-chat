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
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }
    func test_join_chat() {
        sut_chatroom = ChatRoom()
        sut_chatroom.setUpNetwork()
        sut_chatroom.joinChat(username: "James")
    }
}
