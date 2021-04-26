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
    var hostURL = "stream-ios.yagom-academy.kr"
    var port: UInt32 = 7748
    
    func setupNetworkCommunication() {
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, hostURL as CFString, port, &readStream, &writeStream)
        
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        
        inputStream.schedule(in: .current, forMode: .common)
        outputStream.schedule(in: .current, forMode: .common)
        
        inputStream.open()
        outputStream.open()
    }
}
