//
//  TcpError.swift
//  StreamChat
//
//  Created by 강경 on 2021/08/11.
//

import Foundation

enum TcpError: Error {
    
    case noDataReceived
    case failedToReadInputStream
}

extension TcpError: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .noDataReceived:
            return "수신 된 메시지가 없습니다."
        case .failedToReadInputStream:
            return "InputStream을 읽는데 실패해였습니다."
        }
    }
}
