//
//  ChatRoom.swift
//  StreamChat
//
//  Created by steven on 8/12/21.
//

import Foundation

class ChatRoom: NSObject, StreamManagerDelegate {
    let userName: String
    let streamManager: StreamManager
//    var messages = []
    
    init(userName: String, streamManager: StreamManager) {
        self.userName = userName
        self.streamManager = streamManager
        self.streamManager.setup()
        super.init()
        self.streamManager.delegate = self
        self.streamManager.open()
    }
    
    deinit {
        self.streamManager.close()
    }
    
    func received(message: String) {
        
    }
}
