//
//  StreamDataFormat.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/13.
//

import Foundation

enum StreamData {
    static let leaveMessage = "LEAVE::::END"
    
    // MARK: Convert Function
    
    static func convertMessageToJoinFormat(userName: String) -> String {
        return "USR_NAME::\(userName)::END"
    }
    
    static func convertMessageToSendFormat(_ message: String) -> String {
        "MSG::\(message)::END"
    }
    
    static func convertDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.dateFormat = "M월 d일 a h시 m분"
        dateFormatter.amSymbol = "오전"
        dateFormatter.pmSymbol = "오후"
        dateFormatter.timeZone = TimeZone.current

        return dateFormatter.string(from: date)
    }
    
    // MARK: Find Function
    
    static func findOutSenderNameOfMessage(message: String) -> String {
        let splitedMessage = splitMessage(message)
        if splitedMessage.count == 2 {
            return splitedMessage[0]
        }
        return "chatManager"
    }
    
    static func findOutMessageContent(message: String) -> String {
        let splitedMessage = splitMessage(message)
        if splitedMessage.count == 2 {
            return splitedMessage[1]
        }
        return message
    }
    
    static func findOutIdentifierOfMessage(message: String, ownUserName: String) -> SenderIdentifier {
        let splitedMessage = splitMessage(message)
        if splitedMessage.count == 2, ownUserName != splitedMessage[0] {
            return SenderIdentifier.otherUser
        } else if splitedMessage.count == 2, ownUserName == splitedMessage[0] {
            return SenderIdentifier.userSelf
        }
        return SenderIdentifier.chatManager
    }
}

extension StreamData {
    private static func splitMessage(_ message: String) -> [String] {
        message.split(separator: ":").map { String($0) }
    }
}
