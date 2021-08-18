//
//  ChatViewModelProtocol.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/16.
//

import Foundation

protocol ChatViewModelProtocol: ChatViewModelDelegate {
    var onUpdated: (_ newMessages: [Chat], _ oldMessages: [Chat]) -> Void { get set }
    
    func getCountOfMessages() -> Int
    
    func getMessage(row: Int) -> Chat
    
    func resetMessages()
    
    func connectServer()
    
    func send(message: String)
    
    func closeStreamTask()

    func initializeOwnUserName(_ name: String)
}

extension ChatViewModel: ChatViewModelProtocol {
}
