//
//  MessageData.swift
//  StreamChat
//
//  Created by 강경 on 2021/08/11.
//

import Foundation

final class ReceivedData {

    private let receivedString: String
    
    init(receivedString: String) {
        self.receivedString = receivedString
    }
    // TODO: - 과연 이게 최선인가..?
    func processedData() -> MessageData {
        let stringData = receivedString.components(separatedBy: "::")
        if stringData.count == 2 {
            return MessageData(userName: stringData[0], message: stringData[1])
        } else {
            let notificationData = receivedString.components(separatedBy: " ")
            
            return MessageData(userName: notificationData[0],
                               message: "\(notificationData[1]) \(notificationData[2])")
        }
    }
}
