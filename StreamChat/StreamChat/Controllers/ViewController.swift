//
//  StreamChat - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    let chatRoom = ChatRoom(chatNetworkManager: ChatNetworkManager())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatRoom.joinChat(username: "James")
    }
}
