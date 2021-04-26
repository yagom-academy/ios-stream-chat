//
//  ChatRoom.swift
//  StreamChat
//
//  Created by 김태형 on 2021/04/20.
//

import Foundation

class ChatRoom: NSObject {
    
    private var inputStream: InputStream!
    private var outputStream: OutputStream!
    private let maxLength = 300
    private var username = ""
    
    
    func connect() {
        Stream.getStreamsToHost(withName: Host.address, port : Host.port, inputStream: &inputStream, outputStream: &outputStream)
        
        guard let inputStream = self.inputStream,
              let outputStream = self.outputStream else {
            return
        }
        
        inputStream.delegate = self
        outputStream.delegate = self
        
        inputStream.schedule(in: .main, forMode: RunLoop.Mode.default)
        outputStream.schedule(in: .main, forMode: RunLoop.Mode.default)
        
        inputStream.open()
        outputStream.open()
    }
    
    func joinChat(username: String) {
           let joinMessage = "USR_NAME::\(username)".data(using: .utf8)!
           
           self.username = username
           
           joinMessage.withUnsafeBytes {
               guard let output = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                   print("Error joining chat")
                   return
               }
               outputStream.write(output, maxLength: maxLength)
           }
       }
    
    func send(message: String) {
         let message = "MSG::\(message)".data(using: .utf8)!
         
         message.withUnsafeBytes {
             guard let output = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                 print("Error send message")
                 return
             }
             outputStream.write(output, maxLength: maxLength)
         }
     }
    
    func disconnect() {
            inputStream.close()
            outputStream.close()
        }
}

extension ChatRoom: StreamDelegate {
    func stream(_ stream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.errorOccurred:
            print("ErrorOccurred")
        case Stream.Event.openCompleted:
            print("OpenCompleted")
        case Stream.Event.hasBytesAvailable:
            print("HasBytesAvailable")
            readAvailableBytes(stream: stream)
        case Stream.Event.endEncountered:
            print("EndEncountered")
        default:
            print("unknown event")
        }
    }
    
    private func readAvailableBytes(stream: Stream) {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxLength)
        let readByte = inputStream.read(buffer, maxLength: maxLength)
        
        guard let message = String(bytesNoCopy: buffer, length: readByte, encoding: .utf8, freeWhenDone: true) else {
            return
        }
        print(message)
    }
}


