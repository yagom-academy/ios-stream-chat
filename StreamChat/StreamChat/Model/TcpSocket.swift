//
//  TcpSocket.swift
//  StreamChat
//
//  Created by 이영우 on 2021/08/09.
//

import Foundation

protocol TcpSocketDelegate: AnyObject {
    func receive(_ message: String)
}

final class TcpSocket: NSObject {
    private var inputStream: InputStream?
    private var outputStream: OutputStream?
    private let host: String
    private let port: UInt32
    private let maxLength: Int
    weak var delegate: TcpSocketDelegate?
    
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
    
    func send(data: Data) throws {
        try data.withUnsafeBytes {
            guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                throw ChatError.notExistedPointer
            }
            outputStream?.write(pointer, maxLength: data.count)
        }
    }
    
    func disconnect() {
        inputStream?.close()
        outputStream?.close()
    }
}

extension TcpSocket: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .hasBytesAvailable:
            guard let inputStream = aStream as? InputStream else { return }
            readAvailableBytes(stream: inputStream)
        case .endEncountered:
            disconnect()
        case .errorOccurred:
            print("error occurred")
        case .hasSpaceAvailable:
            print("has space available")
        default:
            print("some other event...")
        }
    }
    
    private func readAvailableBytes(stream: InputStream) {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxLength)
        
        while stream.hasBytesAvailable {
            guard let numberOfBytesRead = inputStream?.read(buffer, maxLength: maxLength) else {
                return
            }
            if numberOfBytesRead < 0, let error = stream.streamError {
                print(error)
                break
            }
            if let message = processedString(buffer: buffer, length: numberOfBytesRead) {
                delegate?.receive(message)
            }
        }
    }
    
    private func processedString(buffer: UnsafeMutablePointer<UInt8>,
                                        length: Int) -> String? {
        guard let string = String(bytesNoCopy: buffer, length: length, encoding: .utf8, freeWhenDone: true) else {
            return nil
        }
        return string
    }
}
