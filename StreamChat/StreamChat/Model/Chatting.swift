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
    
    init(userName: String, host: String, port: Int) {
        self.userName = userName
        
        tcpSocket.connect(host: host, port: port)
    }
    func enterTheChatRoom() {
        tcpSocket.send(data: ChattingConstant.enterTheChatRoom(name: userName).format)
    }
    func leaveTheChatRoom() {
        tcpSocket.send(data: ChattingConstant.leaveTheChatRoom)
    }
    func send(message: String) throws {
        if message.count > Integers.maximumNumberOfMessageCharacters {
            throw ChattingError.sendingMessagesIsLimitedTo300
        }
        tcpSocket.send(data: ChattingConstant.send(message: message).format)
    }
    func receivedData() throws -> MessageData {
        let customizedBuffer = try tcpSocket.receive(
            totalSizeOfBuffer: ChattingConstant.totalSizeOfBuffer)
        guard let receivedString = String(bytes: customizedBuffer,
                                          encoding: String.Encoding.utf8) else {
            throw ChattingError.failToConvertCustomizedBufferToString
        }
        
        return MessageDataManager().convertStringToMessageData(receivedString: receivedString)
    }
    func disconnect() {
        tcpSocket.disconnect()
    }
}
