//
//  ChatViewModel.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/10.
//

import Foundation

class ChatViewModel {
    let service = Service()
    var onUpdated: (_ newMessages: [Chat], _ oldMessages: [Chat]) -> Void = { _, _  in }
    
    private var messages: [Chat] = [] {
        didSet {
            onUpdated(messages, oldValue)
        }
    }
    
    func getCountOfMessages() -> Int {
        return messages.count
    }
    
    func insertMessage(chat: Chat) {
        service.send(message: chat.message)
        messages.append(chat)
    }
    
    func getMessage(indexPath: IndexPath) -> Chat {
        return messages[indexPath.row]
    }
    
    func send(message: String) {
        service.send(message: message)
    }
}
