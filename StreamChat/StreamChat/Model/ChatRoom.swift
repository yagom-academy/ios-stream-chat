//
//  ChatRoom.swift
//  StreamChat
//
//  Created by 김태형 on 2021/04/20.
//

import Foundation

class ChatRoom: NSObject, StreamDelegate {
    
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
    
   
}




