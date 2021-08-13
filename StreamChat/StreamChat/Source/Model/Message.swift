//
//  Message.swift
//  StreamChat
//
//  Created by steven on 8/13/21.
//

import Foundation

enum MessageConstant {
    static let userPrefix = "USR_NAME"
    static let sendPrefix = "MSG"
    static let exitPrefix = "LEAVE"
    static let separator = "::"
    static let postfix = "END"
}

enum OutgoingMessage {
    case enter(String)
    case send(String)
    case leave
}

extension OutgoingMessage: CustomStringConvertible {
    var description: String {
        switch self {
        case .enter(let user):
            return MessageConstant.userPrefix +
                    MessageConstant.separator +
                    user +
                    MessageConstant.separator +
                    MessageConstant.postfix
        case .send(let message):
            return MessageConstant.sendPrefix +
                    MessageConstant.separator +
                    message +
                    MessageConstant.separator +
                    MessageConstant.postfix
        case .leave:
            return MessageConstant.exitPrefix +
                    MessageConstant.separator +
                    MessageConstant.separator +
                    MessageConstant.postfix
        }
    }
}

enum MessageType {
    case me
    case other
    case system
}

struct Message {
    let username: String
    let content: String
    let type: MessageType
    
    init(buffer: String, username: String) {
        if buffer.contains(MessageConstant.separator) {
            let strings = buffer.components(separatedBy: MessageConstant.separator)
            self.username = strings[0]
            self.content = strings[1]
            self.type = (self.username == username) ? .me : .other
        } else {
            self.username = ""
            self.content = buffer
            self.type = .system
        }
    }
}
