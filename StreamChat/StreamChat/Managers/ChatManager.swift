//
//  ChatManager.swift
//  StreamChat
//
//  Created by Fezravien on 2021/08/10.
//

import UIKit

final class ChatManager: NSObject {
    private var inputStream: InputStream?
    private var outputStream: OutputStream?
    private var username: String?
    private let maxReadLength = 300
    weak var receiveDelegate: ChatPageDelegate?
    
    override init() {
        super.init()
        self.inputStream?.delegate = self
    }
    
    func setNetwork() {
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           StreamConfig.url as CFString,
                                           StreamConfig.port,
                                           &readStream,
                                           &writeStream)
        
        setInputStream(readStream)
        setOutputStream(writeStream)
    }
    
    func joinChat(username: String) {
        self.username = username
        
        guard let data = StreamFormat.join(username).description.data(using: .utf8),
              let outputStream = outputStream else {
            
            return
        }
        
        data.withUnsafeBytes {
            guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else { return }
            outputStream.write(pointer, maxLength: data.count)
        }
        
    }
    
    func send(message: String) {
        guard let data = StreamFormat.send(message).description.data(using: .utf8),
              let outputStream = outputStream else {
            
            return
        }
        
        data.withUnsafeBytes {
            guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else { return }
            outputStream.write(pointer, maxLength: data.count)
        }
    }
    
    func stopChatSession() {
        leave()
        self.inputStream?.close()
        self.outputStream?.close()
    }
    
    private func leave() {
        guard let data = StreamFormat.exit.description.data(using: .utf8),
              let outputStream = outputStream else {
            
            return
        }
        
        data.withUnsafeBytes {
            guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else { return }
            outputStream.write(pointer, maxLength: data.count)
        }
    }
    
    private func setInputStream(_ readStream: Unmanaged<CFReadStream>?) {
        self.inputStream = readStream?.takeRetainedValue()
        self.inputStream?.schedule(in: .current, forMode: .common)
        self.inputStream?.open()
    }
    
    private func setOutputStream(_ writeStream: Unmanaged<CFWriteStream>?) {
        self.outputStream = writeStream?.takeRetainedValue()
        self.outputStream?.schedule(in: .current, forMode: .common)
        self.outputStream?.open()
    }
}

extension ChatManager: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        guard let inputstream = aStream as? InputStream else { return }
        
        switch eventCode {
        case .hasBytesAvailable:
            readAvailableBytes(stream: inputstream)
        case .endEncountered:
            stopChatSession()
        case .errorOccurred:
            print("error occurred")
        case .hasSpaceAvailable:
            print("has space available")
        default:
            print("some other event...")
        }
    }
    
    private func readAvailableBytes(stream: InputStream) {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxReadLength)
        
        while stream.hasBytesAvailable {
            guard let numberOfBytesRead = inputStream?.read(buffer, maxLength: maxReadLength) else { return }
            
            if numberOfBytesRead < 0, let error = stream.streamError {
                print(error)
                break
            }
            
            guard let message = processedMessageString(buffer: buffer, length: numberOfBytesRead) else { return }
            self.receiveDelegate?.received(message: message)
        }
    }
    
    private func processedMessageString(buffer: UnsafeMutablePointer<UInt8>, length: Int) -> ChatMessage? {
        guard let stringArray = String(bytesNoCopy: buffer,
                                       length: length,
                                       encoding: .utf8,
                                       freeWhenDone: true)?.components(separatedBy: "::"),
              let name = stringArray.first,
              let message = stringArray.last else {
            
            return nil
        }
        let messageSender: UserState = (self.username == name) ? .ourself : .someoneElse
        
        return ChatMessage(message: message, user: ChatUser(username: name, state: messageSender))
    }
}
