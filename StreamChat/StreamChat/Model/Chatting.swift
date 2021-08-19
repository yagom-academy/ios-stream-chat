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
    func enterTheChatRoom() {
        tcpSocket.connect(host: host, port: port)
        tcpSocket.send(data: StreamConstant.enterTheChatRoom(name: userName).format)
    }
    func leaveTheChatRoom() {
        tcpSocket.send(data: StreamConstant.leaveTheChatRoom)
        tcpSocket.disconnect()
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
    private func isStringAppropriateForStreamConnecting(string: String) -> Bool {
        let inappropriateStrings = ["END"]
        for inappropriateString in inappropriateStrings where string == inappropriateString {
            return false
        }
        
        return true
    }
}
