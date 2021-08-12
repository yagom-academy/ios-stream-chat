//
//  StreamManager.swift
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

protocol StreamManagerDelegate: NSObject {
    func received(message: String)
}

class StreamManager: NSObject, StreamDelegate {
    var inputStream: InputStream?
    var outputStream: OutputStream?
    weak var delegate: StreamManagerDelegate?
    
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
        inputStream?.delegate = self
        outputStream?.delegate = self
        inputStream?.schedule(in: .current, forMode: .common)
        outputStream?.schedule(in: .current, forMode: .common)
    }
    
    func open() {
        inputStream?.open()
        outputStream?.open()
    }
    
    func close() {
        inputStream?.close()
        outputStream?.close()
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
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        if eventCode == .hasBytesAvailable {
            readAvailableBytes(stream: aStream as! InputStream)
        }
    }
    
    func readAvailableBytes(stream: InputStream) {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: ChatServerInfo.maxMessageLength)
        
        while stream.hasBytesAvailable {
            let numberOfBytesRead = inputStream?.read(buffer, maxLength: ChatServerInfo.maxMessageLength)
            
            if numberOfBytesRead! < 0, let error = stream.streamError {
                break
            }
            
            guard let bufferString = String(bytesNoCopy: buffer,
                                            length: numberOfBytesRead!,
                                       encoding: .utf8,
                                       freeWhenDone: true) else {
                continue
            }
            delegate?.received(message: bufferString)
        }
    }
}
