//
//  StreamDataFormat.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/13.
//

import Foundation

enum StreamData {
    static var ownUserName: String = ""
    static func joinTheChat(userName: String) -> String {
        StreamData.ownUserName = userName
        return "USR_NAME::\(userName)::END"
    }
    
    static func sendMessage(_ message: String) -> String {
        "MSG::\(message)::END"
    }
    
    static func receiveMessage(_ message: String) -> Chat? {
        let splitedMessage = message.split(separator: ":").map { String($0) }
        if splitedMessage.count == 2, StreamData.ownUserName != splitedMessage[0] {
            return Chat(senderType: Identifier.otherUser,
                        senderName: splitedMessage[0],
                        message: splitedMessage[1],
                        date: Date())
        } else if splitedMessage.count == 2, StreamData.ownUserName == splitedMessage[0] {
            return nil
        }
        
        return Chat(senderType: Identifier.chatManager,
                    senderName: "chatManager",
                    message: message,
                    date: Date())
    }
    
    static func notifyChatJoin(_ message: String) -> String {
        String(message.split(separator: ":")[1])
    }
    
    static let leaveMessage = "LEAVE::::END"
    
    static func convertDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.dateFormat = "M월 d일 a h시 m분"
        dateFormatter.amSymbol = "오전"
        dateFormatter.pmSymbol = "오후"
        dateFormatter.timeZone = TimeZone.current

        return dateFormatter.string(from: date)
    }
}
