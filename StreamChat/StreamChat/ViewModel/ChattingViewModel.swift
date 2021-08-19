//
//  ChattingViewModel.swift
//  StreamChat
//
//  Created by 강경 on 2021/08/17.
//

import Foundation

final class ChattingViewModel {
    
    private let dateFormatter = DateFormatter()
    private var chatting: Chatting?
    private var chatList: [ChatModel] = []
    private var chatName: String = ""
    
    func enterTheChatRoom() {
        chatting?.enterTheChatRoom()
    }
    func setChatting(_ chatting: Chatting) {
        self.chatting = chatting
    }
    func send(message: String) {
        let writtenDate = dateFormatter.convertToStringForChat(date: Date())
        do {
            try chatting?.send(message: message)
        } catch {
            print(error)
        }
        
        let chatModel = ChatModel(message: message, writtenDate: writtenDate)
        print("[chat message] \(chatModel.message) (\(chatModel.writtenDate))")
        chatList.append(chatModel)
    }
    func leaveTheChatRoom() {
        chatting?.leaveTheChatRoom()
    }
    func numberOfChatList() -> Int {
        return chatList.count
    }
    func chatInfo(index: Int) -> ChatModel {
        return chatList[index]
    }
}
