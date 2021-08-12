//
//  ChatMessage.swift
//  StreamChat
//
//  Created by Fezravien on 2021/08/10.
//

import Foundation

struct ChatMessage {
    let message: String
    let user: ChatUser
    
    init(message: String, user: ChatUser) {
        self.message = message.withoutWhitespace()
        self.user = user
    }
}
