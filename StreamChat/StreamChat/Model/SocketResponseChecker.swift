//
//  SocketResponseChecker.swift
//  StreamChat
//
//  Created by 강인희 on 2021/04/29.
//

import Foundation

struct SocketResponseChecker {
    private let bufferSize = 400
    
    func handleReceivedMessage(inputStream: InputStream) -> Message? {
        var buffer = [UInt8](repeating: 0, count: bufferSize)
        let byteLength = inputStream.read(&buffer, maxLength: bufferSize)
        guard byteLength > 0,
              let receivedMessage = String(bytes: buffer, encoding: .utf8) else {
            print(inputStream.streamError)
            return nil
        }
        
        let message: Message? = configureMessage(with: receivedMessage)
        return message
    }
    
    private func configureMessage(with receivedMessage: String) -> Message? {
        let receivedMessage = receivedMessage.replacingOccurrences(of: "\0", with: "")
        
        if receivedMessage.isJoinMessage || receivedMessage.isLeavingMessage {
            return AlarmMessage(content: receivedMessage, receivedTime: Date())
        }
        
        guard let messageInformation = checkMessageFormat(with: receivedMessage) else {
            return nil
        }
        
        if let messageContent = messageInformation["content"],
           let messageSender = messageInformation["sender"] {
            return ChatMessage(content: messageContent, receivedTime: Date(), sender: messageSender)
        }
        
        return nil
    }
    
    private func checkMessageFormat(with message: String) -> [String : String]? {
        guard message.contains("::"),
              let sender = message.components(separatedBy: "::").first,
              let content = message.components(separatedBy: "::").last else {
            return nil
        }
        
        let messageInfo = ["sender" : sender, "content": content]
        
        return messageInfo
    }
}
fileprivate extension String {
    var isJoinMessage: Bool {
        return hasSuffix(String(describing: SocketDataFormat.userJoined))
    }
    
    var isLeavingMessage: Bool {
        return hasSuffix(String(describing: SocketDataFormat.userLeft))
    }
}
