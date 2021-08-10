//
//  ChatPageViewController.swift
//  StreamChat
//
//  Created by Fezravien on 2021/08/10.
//

import UIKit

final class ChatPageViewController: UIViewController {
    private let chatManager = ChatManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectNetwork()
        joinChat()
    }

    private func connectNetwork() {
        self.chatManager.setNetwork()
    }
    
    private func joinChat() {
        self.chatManager.joinChat(username: "")
    }
    
    private func setDelegate() {
        self.chatManager.receiveDelegate = self
    }
}

extension ChatPageViewController: ChatPageDelegate {
    func received(message: ChatMessage) {
        
    }
}
