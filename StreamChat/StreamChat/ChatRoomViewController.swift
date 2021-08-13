//
//  ChatRoomViewController.swift
//  StreamChat
//
//  Created by 이영우 on 2021/08/13.
//

import UIKit

class ChatRoomViewController: UIViewController {
    private let socket = TcpSocket(host: "15.165.55.224", port: 5080)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
