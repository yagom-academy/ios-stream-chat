//
//  StartViewModel.swift
//  StreamChat
//
//  Created by 강경 on 2021/08/17.
//

import Foundation

final class StartViewModel {
    
    private let host = StreamConstant.host
    private let port = StreamConstant.port
    private let chatting: Chatting
    
    init() {
        chatting = Chatting(host: host, port: port)
    }
    func getChatting() -> Chatting {
        return chatting
    }
    func enterTheChatRoom(userName: String) throws {
        try chatting.setUser(name: userName)
        chatting.enterTheChatRoom()
    }
}
