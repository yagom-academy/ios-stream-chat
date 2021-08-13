//
//  SocketResponseHandler.swift
//  StreamChat
//
//  Created by 이영우 on 2021/08/13.
//

import Foundation

struct SocketResponseHandler {
    private let maxBufferSize: Int
    init(maxBufferSize: Int) {
        self.maxBufferSize = maxBufferSize
    }

    func receivedMessage(inputStream: InputStream) -> ChatReceiveFormat? {
        let pointer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxBufferSize)
        var convertedMessage: ChatReceiveFormat?
        while inputStream.hasBytesAvailable {
            let numberOfBytesRead = inputStream.read(pointer, maxLength: maxBufferSize)
            if numberOfBytesRead < 0, let error = inputStream.streamError {
                print(error.localizedDescription)
                return nil
            }
            guard let message = String(bytesNoCopy: pointer,
                                       length: numberOfBytesRead,
                                       encoding: .utf8, freeWhenDone: true) else {
                return nil
            }
            convertedMessage = convert(message)
        }
        return convertedMessage
    }

    private func convert(_ message: String) -> ChatReceiveFormat? {
        let message = message.replacingOccurrences(of: "\0", with: "")

        if message.contains(ChatRoom.messageSeperator) {
            let elements = message.components(separatedBy: ChatRoom.messageSeperator)
            let sender = elements.first!
            let content = elements.last!
            return .message(sender: sender, content: content)
        } else if message.contains(ChatRoom.joinPostfix) {
            if let sender = message.components(separatedBy: ChatRoom.joinPostfix).first {
                return .userJoin(sender: sender)
            }
        } else if message.contains(ChatRoom.leavePostfix) {
            if let sender = message.components(separatedBy: ChatRoom.leavePostfix).first {
                return .userLeave(sender: sender)
            }
        }
        return nil
    }
}
