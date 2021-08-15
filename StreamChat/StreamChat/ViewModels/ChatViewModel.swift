//
//  ChatViewModel.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/10.
//

import Foundation

final class ChatViewModel {
    let networkManager = NetworkManager()
    var onUpdated: (_ newMessages: [Chat], _ oldMessages: [Chat]) -> Void = { _, _  in }
    
    private var messages: [Chat] = [] {
        didSet {
            onUpdated(messages, oldValue)
        }
    }
    
    init() {
        networkManager.delegate = self
    }
    
    func getCountOfMessages() -> Int {
        return messages.count
    }
    
    func insertMessage(chat: Chat) {
        networkManager.send(message: StreamData.convertMessageToSendFormat(chat.message))
        messages.append(chat)
    }
    
    func getMessage(indexPath: IndexPath) -> Chat {
        return messages[indexPath.row]
    }
    
    func resetMessages() {
        messages = []
    }
    
    // MARK: Network function
    
    func send(message: String) {
        networkManager.send(message: message)
    }
    
    func closeStreamTask() {
        networkManager.closeStreamTask()
    }
}

extension ChatViewModel: Receivable {
    func receive(chat: Chat) {
        messages.append(chat)
    }
}
