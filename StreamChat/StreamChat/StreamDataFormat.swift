//
//  StreamDataFormat.swift
//  StreamChat
//
//  Created by 기원우 on 2021/08/16.
//

import Foundation

struct StreamDataFormat {
    static let shared = StreamDataFormat()

    let divisionPoint = "::"
    let divisionSpaceNotifi = " "

    func join(data: String) -> String {
        return "USR_NAME::\(data)::END"
    }

    func sendMessage(data: String) -> String {
        return "MSG::\(data)::END"
    }

    func leave() -> String {
        return "LEAVE::::END"
    }

    func receiveMessage(username: String, message: String) -> String {
        return "\(username) : \(message)"
    }

    func othreUserChatStatus(username: String, status: String) -> String {
        return "\(username) has \(status)"
    }
}
