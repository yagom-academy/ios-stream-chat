//
//  StreamChat - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ChatRoomViewController: UIViewController {
    let chatRoom = ChatRoom()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chatRoom.delegate = self
        chatRoom.setupNetworkCommunication()
        chatRoom.joinChat(username: "")
    }
}

extension ChatRoomViewController: ChatRoomDelegate {
    func receive(message: Message) {
        // insertNewMessageCell
    }
}
