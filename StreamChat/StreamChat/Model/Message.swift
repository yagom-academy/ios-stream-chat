//
//  Message.swift
//  StreamChat
//
//  Created by 김동빈 on 2021/04/27.
//

import Foundation

enum MessageSender {
    case ourself
    case someoneElse
}

struct Message {
    let message: String
    let senderUsername: String
    let messageSender: MessageSender
    
    init(message: String, messageSender: MessageSender, username: String) {
        self.message = message
        self.messageSender = messageSender
        self.senderUsername = username
    }
}
