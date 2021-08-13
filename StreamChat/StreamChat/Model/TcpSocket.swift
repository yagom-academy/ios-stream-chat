//
//  TcpSocket.swift
//  StreamChat
//
//  Created by 이영우 on 2021/08/09.
//

import Foundation

final class TcpSocket: NSObject {
    private var inputStream: InputStream?
    private var outputStream: OutputStream?
    private let host: String
    private let port: UInt32
    private let maxLength: Int
    
    init(host: String, port: UInt32, maxLength: Int = 300) {
        self.host = host
        self.port = port
        self.maxLength = maxLength
        super.init()
        connect()
    }
    
    private func connect() {
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorSystemDefault, host as CFString, port, &readStream, &writeStream)
        if let readStream = readStream, let writeStream = writeStream {
            inputStream = readStream.takeRetainedValue()
            outputStream = writeStream.takeRetainedValue()
        }
        if inputStream != nil && outputStream != nil {
            inputStream?.delegate = self
            inputStream?.schedule(in: .main, forMode: .default)
            outputStream?.schedule(in: .main, forMode: .default)
            inputStream?.open()
            outputStream?.open()
        }
    }
}

extension TcpSocket: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        
    }
}
