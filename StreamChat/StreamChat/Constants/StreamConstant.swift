//
//  StreamConstant.swift
//  StreamChat
//
//  Created by 강경 on 2021/08/11.
//

import Foundation

enum StreamConstant {
    
    case enterTheChatRoom(name: String)
    case send(message: String)
    case leaveTheChatRoom
    
    var format: String {
        switch self {
        case .enterTheChatRoom(let name):
            return "USR_NAME::\(name)::END"
        case .send(let message):
            return "MSG::\(message)::END"
        case .leaveTheChatRoom:
            return "LEAVE::::END"
        }
    }
    static let host = "15.165.55.224"
    static let port = 5080
    static let totalSizeOfBuffer = 1024
    static let receiveStreamData = "ReceiveStreamData"
}
