//
//  ChatConfiguration.swift
//  StreamChat
//
//  Created by Fezravien on 2021/08/12.
//

import Foundation

enum ChatConfiguration {
    enum userState {
        case ourself
        case someoneElse
    }
    
    enum stream {
        static let url = "15.165.55.224"
        static let port: UInt32 = 5080
    }
}
