//
//  ChatConfiguration.swift
//  StreamChat
//
//  Created by Fezravien on 2021/08/12.
//

import Foundation


enum UserState {
    case ourself
    case someoneElse
}

enum StreamConfig {
    static let url = "15.165.55.224"
    static let port: UInt32 = 5080
    static let maxReadLength = 300
}

enum StreamFormat {
    case join(String)
    case send(String)
    case exit
}

extension StreamFormat: CustomStringConvertible {
    var description: String {
        switch self {
        case .join(let username):
            return "USR_NAME::\(username)::END"
        case .send(let message):
            return "MSG::\(message)::END"
        case .exit:
            return "LEAVE::::END"
        }
    }
}
