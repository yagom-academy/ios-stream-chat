//
//  StreamChat - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    private var chatManager = ChatManager()
    private var messageContainer = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatManager.delegate = self
    }
}
extension ViewController: MessageReceivable {
    func receive(message: Message?) {
        guard let receivedMessage = message else {
            print("메시지 수신 실패")
            return
        }
        
        self.messageContainer.append(receivedMessage)
    }
}
