//
//  StreamChat - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ChatRoomViewController: UIViewController {

    let chatRoomViewModel = ChatRoomViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func join(with username: String) {
        chatRoomViewModel.join(with: username)
    }
}
