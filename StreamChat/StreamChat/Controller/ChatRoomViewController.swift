//
//  StreamChat - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ChatRoomViewController: UIViewController {
    
    let chatRoom = ChatRoom()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chatRoom.connect()
        chatRoom.joinChat(username: "taetae")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        chatRoom.disconnect()
    }
    
}

