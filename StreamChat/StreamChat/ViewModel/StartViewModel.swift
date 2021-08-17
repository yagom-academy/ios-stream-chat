//
//  StartViewModel.swift
//  StreamChat
//
//  Created by 강경 on 2021/08/17.
//

import Foundation

class StartViewModel {
    private let host = ChattingConstant.host
    private let port = ChattingConstant.port
    
    func enterTheChatRoom(userName: String) throws {
        let chatting = try Chatting(userName: userName, host: host, port: port)
        chatting.enterTheChatRoom()
    }
}
