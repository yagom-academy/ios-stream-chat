//
//  StreamChatTests.swift
//  StreamChatTests
//
//  Created by 강경 on 2021/08/11.
//

import XCTest
@testable import StreamChat

class StreamChatTests: XCTestCase {
    
    let host = ChattingConstant.host
    let port = ChattingConstant.port
    let userName = "TestName"
    let actName = "act"
    let observerName = "observer"
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    // TODO: - Server에 의존하지 않는 테스트 구현
    // MARK: - 메시지 전송 및 수신
    func test_메시지_전송_및_수신() throws {
        let messageToSend = "message for test"
        let chatting = Chatting(userName: userName, host: host, port: port)
        chatting.enterTheChatRoom()
        try chatting.send(message: messageToSend)
        
        let receivedData = try chatting.receivedData()
        let receivedMessage = receivedData.message
        
        chatting.leaveTheChatRoom()
        chatting.disconnect()
        
        XCTAssertEqual(messageToSend, receivedMessage)
    }
    // TODO: - 보내는 메시지 글자수 제한 테스트 구현 -> server에 의존하지 않게 만들면 되나..?
    // MARK: - 채팅참가 알림 및 수신
    func test_채팅참가_알림_및_수신() throws {
        let chatParticipationNotification = "\(actName) has joined"
        let chattingOfObserver = Chatting(userName: observerName, host: host, port: port)
        chattingOfObserver.enterTheChatRoom()
        
        let chattingOfAct = Chatting(userName: actName, host: host, port: port)
        chattingOfAct.enterTheChatRoom()
        
        let receivedData = try chattingOfObserver.receivedData()
        let receivedMessage = "\(receivedData.userName) \(receivedData.message)"
        // TODO: - 비동기 처리..?
        chattingOfAct.leaveTheChatRoom()
        chattingOfAct.disconnect()
        chattingOfObserver.leaveTheChatRoom()
        chattingOfObserver.disconnect()

        XCTAssertEqual(chatParticipationNotification, receivedMessage)
    }
    
    // MARK: - 채팅방 나가기 알림 및 수신
    func test_채팅방_나가기_알림_및_수신() throws {
        let leaveChatNotification = "\(actName) has left"
        let chattingOfObserver = Chatting(userName: observerName, host: host, port: port)
        chattingOfObserver.enterTheChatRoom()
        
        let chattingOfAct = Chatting(userName: actName, host: host, port: port)
        chattingOfAct.enterTheChatRoom()
        
        let chatParticipationNotification = try chattingOfObserver.receivedData()
        chattingOfAct.leaveTheChatRoom()
        
        let receivedData = try chattingOfObserver.receivedData()
        let receivedMessage = "\(receivedData.userName) \(receivedData.message)"
        // TODO: - 비동기 처리..?
        chattingOfAct.disconnect()
        chattingOfObserver.leaveTheChatRoom()
        chattingOfObserver.disconnect()

        XCTAssertEqual(leaveChatNotification, receivedMessage)
    }
}
