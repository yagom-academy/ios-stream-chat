//
//  StreamChat - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    let chat = StreamChat()
    override func viewDidLoad() {
        super.viewDidLoad()

        chat.setupNetworkCommunication()
        chat.joinChat(username: "모둠요리사")
        sleep(1)
        chat.sendChat(message: "무슨 요리가 먹고 싶으세요?")
    }
}

