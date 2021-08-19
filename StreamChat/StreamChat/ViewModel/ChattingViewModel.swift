//
//  ChattingViewModel.swift
//  StreamChat
//
//  Created by 강경 on 2021/08/17.
//

import Foundation

final class ChattingViewModel {
    
    // TODO: - stream 연결
    private var chatList: [ChatModel] = []
    private var chatName: String = ""
    
    func setUserName(name: String) {
        chatName = name
    }
    func userName() -> String {
        return chatName
    }
    func send(chatModel: ChatModel) {
        print("[chat message] \(chatModel.user): \(chatModel.message) (\(chatModel.writtenDate))")
        chatList.append(chatModel)
    }
    func numberOfChatList() -> Int {
        return chatList.count
    }
    func chatInfo(index: Int) -> ChatModel {
        return chatList[index]
    }
}
