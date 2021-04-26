//
//  ChatRoom.swift
//  StreamChat
//
//  Created by 김동빈 on 2021/04/27.
//

import UIKit

class ChatRoom: NSObject {
    var inputStream: InputStream!
    var outputStream: OutputStream!
    var username = ""
    let maxReadLength = 300
}
