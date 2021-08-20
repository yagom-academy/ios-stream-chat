//
//  StreamChatTests.swift
//  StreamChatTests
//
//  Created by 강경 on 2021/08/11.
//

import XCTest
@testable import StreamChat

final class StreamChatTests: XCTestCase {
    
    let host = StreamConstant.host
    let port = StreamConstant.port
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
        let chatting = Chatting(host: host, port: port)
        try chatting.setUser(name: userName)
        chatting.enterTheChatRoom()
        try chatting.send(message: messageToSend)
        
        let receivedData = try chatting.receivedData()
        let receivedMessage = receivedData.message
        
        chatting.leaveTheChatRoom()
        
        XCTAssertEqual(messageToSend, receivedMessage)
    }
    
    func test_보내는_메시지_글자수_제한() throws {
        let sixtyCharacterString = "012345678901234567890123456789012345678901234567890123456789"
        let threeHundredCharacterString = """
            \(sixtyCharacterString)\(sixtyCharacterString)\(sixtyCharacterString)
            \(sixtyCharacterString)\(sixtyCharacterString)
            """
        let messageToSend = threeHundredCharacterString
        let chatting = Chatting(host: host, port: port)
        try chatting.setUser(name: userName)
        chatting.enterTheChatRoom()
        
        do {
            try chatting.send(message: messageToSend)
        } catch {
            let stringOfError: String = "\(error)"
            XCTAssertEqual(stringOfError, ChattingError.sendingMessageIsLimitedToMaximum.description)
        }
        
        chatting.leaveTheChatRoom()
    }
    
    // MARK: - 채팅참가 알림 및 수신
    func test_채팅참가_알림_및_수신() throws {
        let chatParticipationNotification = "\(actName) has joined"
        let chattingOfObserver = Chatting(host: host, port: port)
        try chattingOfObserver.setUser(name: observerName)
        chattingOfObserver.enterTheChatRoom()
        
        let chattingOfAct = Chatting(host: host, port: port)
        try chattingOfAct.setUser(name: actName)
        chattingOfAct.enterTheChatRoom()
        
        let receivedData = try chattingOfObserver.receivedData()
        let receivedMessage = "\(receivedData.userName) \(receivedData.message)"
        chattingOfAct.leaveTheChatRoom()
        chattingOfObserver.leaveTheChatRoom()

        XCTAssertEqual(chatParticipationNotification, receivedMessage)
    }
    
    // MARK: - 채팅방 나가기 알림 및 수신
    func test_채팅방_나가기_알림_및_수신() throws {
        let leaveChatNotification = "\(actName) has left"
        let chattingOfObserver = Chatting(host: host, port: port)
        try chattingOfObserver.setUser(name: observerName)
        chattingOfObserver.enterTheChatRoom()
        
        let chattingOfAct = Chatting(host: host, port: port)
        try chattingOfAct.setUser(name: actName)
        chattingOfAct.enterTheChatRoom()
        
        _ = try chattingOfObserver.receivedData()
        chattingOfAct.leaveTheChatRoom()
        
        let receivedData = try chattingOfObserver.receivedData()
        let receivedMessage = "\(receivedData.userName) \(receivedData.message)"
        chattingOfObserver.leaveTheChatRoom()

        XCTAssertEqual(leaveChatNotification, receivedMessage)
    }
    
    func test_아이디_올바른_String값_적절성판단() throws {
        let validName = "TestName"
        let messageToSend = "message for test"
        let chatting = Chatting(host: host, port: port)
        try chatting.setUser(name: userName)
        chatting.enterTheChatRoom()
        try chatting.send(message: messageToSend)
        
        let receivedData = try chatting.receivedData()
        let receivedUserName = receivedData.userName
        
        chatting.leaveTheChatRoom()
        
        XCTAssertEqual(validName, receivedUserName)
    }
    
    func test_아이디_올바르지않은_String값_적절성판단() throws {
        let invalidName = "END"
        let chatting = Chatting(host: host, port: port)
        do {
            _ = try chatting.setUser(name: invalidName)
        } catch {
            let stringOfError: String = "\(error)"
            XCTAssertEqual(stringOfError, ChattingError.unavailableCharactersWereUsed.description)
        }
    }
}
