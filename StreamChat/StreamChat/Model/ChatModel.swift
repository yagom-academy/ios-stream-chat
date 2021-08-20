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
    let isMyMessage: Bool
    
    // TODO: - Bool.random() 삭제
    // TODO: - user: String = "" 삭제
    init(user: String = "", message: String, writtenDate: String, isMyMessage: Bool = Bool.random()) {
        self.user = user
        self.message = message
        self.writtenDate = writtenDate
        self.isMyMessage = isMyMessage
    }
}
