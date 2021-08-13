//
//  ChatDataFormat.swift
//  StreamChat
//
//  Created by 이영우 on 2021/08/13.
//

import Foundation

enum ChatReceiveFormat {
    case message(sender: String, content: String)
    case userJoin(sender: String)
    case userLeave(sender: String)
}
