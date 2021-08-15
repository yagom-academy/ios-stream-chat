//
//  ChatViewModel.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/10.
//

import Foundation

final class ChatViewModel {
    private let networkManager: NetworkManager
    private var ownUserName: String?
    var onUpdated: (_ newMessages: [Chat], _ oldMessages: [Chat]) -> Void = { _, _  in }
    
    private var messages: [Chat] = [] {
        didSet {
            onUpdated(messages, oldValue)
        }
    }
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        networkManager.delegate = self
    }
    
    func getCountOfMessages() -> Int {
        return messages.count
    }
    
    func getMessage(indexPath: IndexPath) -> Chat {
        return messages[indexPath.row]
    }
    
    func resetMessages() {
        messages = []
    }
    
    // MARK: Network function
    
    func connectServer() {
        networkManager.connectServer()
    }
    
    func send(message: String) {
        networkManager.send(message: message)
    }
    
    func closeStreamTask() {
        networkManager.closeStreamTask()
    }
    
    func initializeOwnUserName(_ name: String) {
        ownUserName = name
    }
    
}

extension ChatViewModel: ChatViewModelDelegate {
    func chatViewModelWillAppendChatInMessages(_ message: String) {
        guard let ownUserName = ownUserName else { return }
        let senderType = StreamData.findOutIdentifierOfMessage(message: message, ownUserName: ownUserName)
        let senderName = StreamData.findOutSenderNameOfMessage(message: message)
        let messageContent = StreamData.findOutMessageContent(message: message)
        let chat = Chat(senderType: senderType,
                        senderName: senderName,
                        message: messageContent,
                        date: Date())
        messages.append(chat)
    }
}
