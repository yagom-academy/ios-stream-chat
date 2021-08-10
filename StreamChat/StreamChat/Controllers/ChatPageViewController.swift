//
//  ChatPageViewController.swift
//  StreamChat
//
//  Created by Fezravien on 2021/08/10.
//

import UIKit

final class ChatPageViewController: UIViewController {
    private let chatManager = ChatManager()
    weak var receiveDelegate: ChatPageDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectNetwork()
        joinChat()
    }

    private func connectNetwork() {
        chatManager.setNetwork()
    }
    
    private func joinChat() {
        chatManager.joinChat(username: "")
    }
}
