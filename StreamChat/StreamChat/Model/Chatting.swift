//
//  Chatting.swift
//  StreamChat
//
//  Created by 강경 on 2021/08/10.
//

import Foundation

final class Chatting {
    
    private let tcpSocket = TcpSocket()
    private let host: String
    private let port: Int
    private var userName = ""
    
    init(host: String, port: Int) {
        self.host = host
        self.port = port
    }
    func setUser(name: String) throws {
        if !isStringAppropriateForStreamConnecting(string: name) {
            throw ChattingError.unavailableCharactersWereUsed
        }
        userName = name
    }
    func ownName() -> String {
        return userName
    }
    func enterTheChatRoom() {
        tcpSocket.connect(host: host, port: port)
        tcpSocket.send(data: StreamConstant.enterTheChatRoom(name: userName).format)
    }
    func leaveTheChatRoom() {
        tcpSocket.send(data: StreamConstant.leaveTheChatRoom.format)
        tcpSocket.disconnect()
    }
    func send(message: String) throws {
        if message.count > MessageIntegers.maximumNumberOfMessageCharacters {
            throw ChattingError.sendingMessageIsLimitedToMaximum
        }
        tcpSocket.send(data: StreamConstant.send(message: message).format)
    }
    private func isStringAppropriateForStreamConnecting(string: String) -> Bool {
        let inappropriateStrings = ["END"]
        for inappropriateString in inappropriateStrings where string == inappropriateString {
            return false
        }
        
        return true
    }
}
