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
    }

    private func connectNetwork() {
        chatManager.setNetwork()
    }
}
