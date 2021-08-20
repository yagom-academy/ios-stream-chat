//
//  ChatModel.swift
//  StreamChat
//
//  Created by 강경 on 2021/08/18.
//

import Foundation

struct ChatModel {
    
    let user: String
    let message: String
    let writtenDate: String
    let messageType: MessageType
    
    init(user: String, message: String, writtenDate: String, messageType: MessageType) {
        self.user = user
        self.message = message
        self.writtenDate = writtenDate
        self.messageType = messageType
    }
}
