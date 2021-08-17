//
//  ChatRoomViewController.swift
//  StreamChat
//
//  Created by 황인우 on 2021/08/17.
//

import UIKit

class ChatRoomViewController: UIViewController {
    
    let chatRoom = ChatRoom(chatNetworkManager: ChatNetworkManager())
    var username = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chatRoom.joinChat(username: username)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        chatRoom.leaveChat()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
