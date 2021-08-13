//
//  SocketResponseHandler.swift
//  StreamChat
//
//  Created by 이영우 on 2021/08/13.
//

import Foundation

struct SocketResponseHandler {
    private let maxBufferSize = 300

    func receivedMessage(inputStream: InputStream) -> ChatDataFormat? {
        let pointer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxBufferSize)
        var convertedMessage: ChatDataFormat?
        while inputStream.hasBytesAvailable {
            let numberOfBytesRead = inputStream.read(pointer, maxLength: maxBufferSize)
            if numberOfBytesRead < 0, let error = inputStream.streamError {
                print(error.localizedDescription)
                return nil
            }
            guard let message = String(bytesNoCopy: pointer, length: numberOfBytesRead, encoding: .utf8, freeWhenDone: true) else {
                return nil
            }
            convertedMessage = convert(message)
        }
        return convertedMessage
    }
    
    private func convert(_ message: String) -> ChatDataFormat? {
        let message = message.replacingOccurrences(of: "\0", with: "")
        
        if message.contains("::") == true {
            let elements = message.components(separatedBy: "::")
            let sender = elements.first!
            let content = elements.last!
            return ChatDataFormat.message(sender: sender, content: content)
        } else if message.contains("has joined") == true {
            let sender = message.components(separatedBy: " has joined").first!
            return ChatDataFormat.userJoin(sender: sender)
        } else if message.contains("has left") == true {
            let sender = message.components(separatedBy: " has left").first!
            return ChatDataFormat.userLeave(sender: sender)
        }
        return nil
    }
}
