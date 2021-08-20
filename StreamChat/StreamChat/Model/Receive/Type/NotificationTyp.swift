//
//  NotificationTyp.swift
//  StreamChat
//
//  Created by 강경 on 2021/08/20.
//

import Foundation

enum NotificationType: String {

    case entrance = "joined", exit = "left"
    
    static let stringOfCommonGround = "님이"
    static let stringOfEntrance = "들어왔습니다."
    static let stringOfExit = "나갔습니다."

    var fullMessage: String {
        switch self {
        case .entrance:
            return "\(NotificationType.stringOfCommonGround) \(NotificationType.stringOfEntrance)"
        case .exit:
            return "\(NotificationType.stringOfCommonGround) \(NotificationType.stringOfExit)"
        }
    }
}
