//
//  SessionManager.swift
//  StreamChat
//
//  Created by steven on 8/11/21.
//

import Foundation

enum ChatServerInfo {
    static let url = "15.165.55.224"
    static let port: UInt32 = 5080
    static let maxMessageLength = 300
}

class StreamManager {
    var inputStream: InputStream?
    var outputStream: OutputStream?
    
    func setup() {
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           ChatServerInfo.url as CFString,
                                           ChatServerInfo.port,
                                           &readStream,
                                           &writeStream)
        inputStream = readStream?.takeRetainedValue()
        outputStream = writeStream?.takeRetainedValue()
        
        inputStream?.schedule(in: .current, forMode: .common)
        outputStream?.schedule(in: .current, forMode: .common)
    }
    
    func open() {
        inputStream?.open()
        outputStream?.open()
    }
    
    func close() {
        inputStream?.open()
        outputStream?.open()
    }
    
    func send(message: String) {
        guard let data = message.data(using: .utf8) else {
            return
        }
        
        _ = data.withUnsafeBytes {
            guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                return
            }
            outputStream?.write(pointer, maxLength: data.count)
        }
    }
    
    func receive() -> String {
        var message: String = ""
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: ChatServerInfo.maxMessageLength)
        
        while inputStream!.hasBytesAvailable {
            let numberOfBytesRead = inputStream!.read(buffer, maxLength: ChatServerInfo.maxMessageLength)
            
            if numberOfBytesRead < 0, let error = inputStream?.streamError {
                break
            }
            
            guard let bufferString = String(bytesNoCopy: buffer,
                                       length: numberOfBytesRead,
                                       encoding: .utf8,
                                       freeWhenDone: true) else {
                break
            }
            message = bufferString
        }
        return message
    }
}
