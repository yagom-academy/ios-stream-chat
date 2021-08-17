//
//  MessageDataManager.swift
//  StreamChat
//
//  Created by 강경 on 2021/08/11.
//

import Foundation

final class MessageDataManager {
    
    func convertStringToMessageData(receivedString: String) -> MessageData {
        if isTypeOfChat(string: receivedString) {
            return chatMessageData(messageString: receivedString)
        } else {
            return notificationMessageData(messageString: receivedString)
        }
    }
    private func isTypeOfChat(string: String) -> Bool {
        let stringArray = string.components(separatedBy: "::")
        
        if stringArray.count == MessageIntegers.suitableForChatMessageData {
            return true
        } else {
            return false
        }
    }
    private func chatMessageData(messageString: String) -> MessageData {
        let stringData = messageString.components(separatedBy: "::")
        
        return MessageData(userName: stringData[0], message: stringData[1])
    }
    private func notificationMessageData(messageString: String) -> MessageData {
        let stringData = messageString.components(separatedBy: " ")
        
        return MessageData(userName: stringData[0], message: "\(stringData[1]) \(stringData[2])")
    }
}
