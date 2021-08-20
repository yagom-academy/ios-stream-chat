//
//  ChattingError.swift
//  StreamChat
//
//  Created by 강경 on 2021/08/10.
//

import Foundation

enum ChattingError: Error {
    
    case sendingMessageIsLimitedToMaximum
    case failToConvertCustomizedBufferToString
    case unavailableCharactersWereUsed
}

extension ChattingError: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .sendingMessageIsLimitedToMaximum:
            return "보내는 메시지는 \(MessageIntegers.maximumNumberOfMessageCharacters)자로 길이를 제한합니다."
        case .failToConvertCustomizedBufferToString:
            return "CustomizedBuffer를 String으로 변환하는데 실패하였습니다."
        case .unavailableCharactersWereUsed:
            return "사용할 수 없는 글자를 사용하였습니다."
        }
    }
}
