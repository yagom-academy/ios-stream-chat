//
//  ChatMessage.swift
//  StreamChat
//
//  Created by Fezravien on 2021/08/10.
//

import Foundation

struct ChatMessage {
    let message: String
    let username: String
    let messageSender: ChatMessageState
    
    init(message: String, username: String, messageSender: ChatMessageState) {
        self.message = message.withoutWhitespace()
        self.username = username
        self.messageSender = messageSender
    }
}
