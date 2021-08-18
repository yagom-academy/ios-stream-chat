//
//  Chatting.swift
//  StreamChat
//
//  Created by 강경 on 2021/08/10.
//

import Foundation

final class Chatting {
    
    let tcpSocket = TcpSocket()
    let userName: String
    
    init(userName: String, host: String, port: Int) throws {
        self.userName = userName
        if !isStringAppropriateForStreamConnecting(string: userName) {
            throw ChattingError.unavailableCharactersWereUsed
        }

        tcpSocket.connect(host: host, port: port)
    }
    func setUser(name: String) {
        
    }
    func enterTheChatRoom() {
        tcpSocket.send(data: StreamConstant.enterTheChatRoom(name: userName).format)
    }
    func leaveTheChatRoom() {
        tcpSocket.send(data: StreamConstant.leaveTheChatRoom)
    }
    func send(message: String) throws {
        if message.count > Integers.maximumNumberOfMessageCharacters {
            throw ChattingError.sendingMessagesIsLimitedTo300
        }
        tcpSocket.send(data: StreamConstant.send(message: message).format)
    }
    func receivedData() throws -> MessageData {
        let customizedBuffer = try tcpSocket.receive(
            totalSizeOfBuffer: StreamConstant.totalSizeOfBuffer)
        guard let receivedString = String(bytes: customizedBuffer,
                                          encoding: String.Encoding.utf8) else {
            throw ChattingError.failToConvertCustomizedBufferToString
        }
        let data = ReceivedData(receivedString: receivedString)
        
        return data.processedData()
    }
    func disconnect() {
        tcpSocket.disconnect()
    }
    private func isStringAppropriateForStreamConnecting(string: String) -> Bool {
        let inappropriateStrings = ["END"]
        for inappropriateString in inappropriateStrings where string == inappropriateString {
            return false
        }
        
        return true
    }
}
