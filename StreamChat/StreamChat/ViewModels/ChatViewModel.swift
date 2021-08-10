//
//  ChatViewModel.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/10.
//

import Foundation

struct ChatViewModel {
    
    private var messages: [Chat] = []
    
    func getCountOfMessages() -> Int {
        return messages.count
    }
    
}
