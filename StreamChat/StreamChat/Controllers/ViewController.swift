//
//  StreamChat - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    let chatRoom = ChatRoom()
    override func viewDidLoad() {
        super.viewDidLoad()
        chatRoom.setUpNetwork()
        chatRoom.joinChat(username: "James")
    }
}
