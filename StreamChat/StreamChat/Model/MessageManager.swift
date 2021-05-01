//
//  MessageManager.swift
//  StreamChat
//
//  Created by 강인희 on 2021/04/30.
//

import Foundation

class MessageManager: MessageReceivable {
    private var messageContainer = [Message]()
    
    func receive(message: Message?) {
        guard let receivedMessage = message else {
            print("메시지 수신 실패")
            return
        }
        
        self.messageContainer.append(receivedMessage)
    }
}
