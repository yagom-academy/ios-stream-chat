//
//  ChatModel.swift
//  StreamChat
//
//  Created by 강경 on 2021/08/18.
//

import Foundation

struct ChatModel {
    
    let user: String = ""
    let message: String
    let writtenDate: String
    // TODO: - Bool.random() 삭제
    let isMyMessage: Bool = Bool.random()
}
