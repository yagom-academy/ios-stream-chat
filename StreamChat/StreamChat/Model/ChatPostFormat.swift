//
//  ChatPostFormat.swift
//  StreamChat
//
//  Created by 이영우 on 2021/08/13.
//

import Foundation

enum ChatPostFormat: CustomStringConvertible {
    case myJoin(userName: String)
    case myDisconnect
    case post(message: String)

    var description: String {
        switch self {
        case .myJoin(let name):
            return "USR_NAME::\(name)::END"
        case .myDisconnect:
            return "LEAVE::::END"
        case .post(let message):
            return "MSG::\(message)::END"
        }
    }

    var data: Data? {
        return self.description.data(using: .utf8)
    }
}
