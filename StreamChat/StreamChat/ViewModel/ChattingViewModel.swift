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
    var chatList: Observable<[ChatModel]> = Observable([])
    var numberOfChatList: Int {
        return chatList.value?.count ?? 0
    }
    var currentWritenDate: String {
        return dateFormatter.convertToStringForChat(date: Date())
    }
    
    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.receiveStreamData(_:)),
                                               name: Notification.Name(StreamConstant
                                                                        .receiveStreamData),
                                               object: nil)
    }
    @objc private func receiveStreamData(_ notification: Notification) {
        if let messageData = notification.object as? MessageData,
           messageData.userName != chatting?.ownName() {
            let chatModel = ChatModel(user: messageData.userName, message: messageData.message,
                                      writtenDate: currentWritenDate,
                                      messageType: messageData.messageType)
            chatList.value?.append(chatModel)
        }
    }
    func enterTheChatRoom() {
        chatting?.enterTheChatRoom()
    }
    func setChatting(_ chatting: Chatting) {
        self.chatting = chatting
    }
    func send(message: String) {
        do {
            try chatting?.send(message: message)
        } catch {
            print(error)
        }
        let chatModel = ChatModel(user: chatting?.ownName() ?? "", message: message,
                                  writtenDate: currentWritenDate, messageType: .ownChat)
        chatList.value?.append(chatModel)
    }
    func leaveTheChatRoom() {
        NotificationCenter.default.removeObserver(Notification.Name(StreamConstant
                                                                        .receiveStreamData))
        chatting?.leaveTheChatRoom()
    }
    func chatInfo(index: Int) -> ChatModel {
        return chatList.value![index]
    }
}
