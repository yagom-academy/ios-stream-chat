//
//  ChatRoom.swift
//  StreamChat
//
//  Created by James on 2021/08/12.
//

import UIKit

final class ChatRoom: NSObject {
    
    // MARK: - Properties
    var username = ""
    var chatNetworkManager: ChatNetworkManageable
    
    // MARK: - Methods
    
    init(chatNetworkManager: ChatNetworkManageable) {
        self.chatNetworkManager = chatNetworkManager
        chatNetworkManager.setUpNetwork()
    }
    
    func joinChat(username: String) {
        guard let data = "USR_NAME::\(username)::END".data(using: .utf8) else {
            
            return
        }
        chatNetworkManager.write(data: data)
    }
    
    func send(_ message: String) {
        guard let data = "MSG::\(message)::END".data(using: .utf8) else {
            
            return
        }
        chatNetworkManager.write(data: data)
    }
    
    func leaveChat() {
        guard let data = "LEAVE::::END".data(using: .utf8) else {
            
            return
        }
        chatNetworkManager.write(data: data)
        chatNetworkManager.closeStream()
    }
}
