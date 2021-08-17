//
//  ChattingError.swift
//  StreamChat
//
//  Created by 강경 on 2021/08/10.
//

import Foundation

enum ChattingError: Error, CustomStringConvertible {
    
    case sendingMessagesIsLimitedTo300
    case failToConvertCustomizedBufferToString
    case unavailableCharactersWereUsed
}

extension ChattingError {
    
    var description: String {
        switch self {
        case .sendingMessagesIsLimitedTo300:
            return "보내는 메시지는 300자로 길이를 제한합니다."
        case .failToConvertCustomizedBufferToString:
            return "CustomizedBuffer를 String으로 변환하는데 실패하였습니다."
        case .unavailableCharactersWereUsed:
            return "사용할 수 없는 글자를 사용하였습니다."
        }
    }
}
