//
//  ChatManager.swift
//  StreamChat
//
//  Created by Fezravien on 2021/08/10.
//

import UIKit

final class ChatManager {
    private var inputStream: InputStream?
    private var outputStream: OutputStream?
    private var username: String?
    private let maxReadLength = 300
    
    func setNetwork() {
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           "15.165.55.224" as CFString,
                                           5080,
                                           &readStream,
                                           &writeStream)
        
        setInputStream(readStream)
        setOutputStream(writeStream)
    }
    
    private func setInputStream(_ readStream: Unmanaged<CFReadStream>?) {
        inputStream = readStream?.takeRetainedValue()
        inputStream?.schedule(in: .current, forMode: .common)
        inputStream?.open()
    }
    
    private func setOutputStream(_ writeStream: Unmanaged<CFWriteStream>?) {
        outputStream = writeStream?.takeRetainedValue()
        outputStream?.schedule(in: .current, forMode: .common)
        outputStream?.open()
    }
}
