//
//  NetworkManager.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/12.
//

import Foundation
import UIKit

final class NetworkManager: NSObject {
    
    private var session: URLSession?
    private var inputStream: InputStream?
    private var outputStream: OutputStream?
    weak var delegate: Receivable?
    
    override init() {
        super.init()
    }
    
    func connectServer() {
        session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        let task = session?.streamTask(withHostName: Secret.ipAddress, port: Secret.port)
        task?.resume()
        task?.captureStreams()
    }
    
    func send(message: String) {
        guard let data = message.data(using: .utf8) else { return }
        outputStream?.write(data: data)
    }

}

extension NetworkManager: URLSessionStreamDelegate {
    func urlSession(_ session: URLSession, streamTask: URLSessionStreamTask, didBecome inputStream: InputStream, outputStream: OutputStream) {
        self.outputStream = outputStream
        self.inputStream = inputStream
        
        outputStream.delegate = self
        inputStream.delegate = self
        
        inputStream.schedule(in: .main, forMode: .default)
        outputStream.schedule(in: .main, forMode: .default)
        
        inputStream.open()
        outputStream.open()
    }
}

extension NetworkManager: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        if inputStream == aStream {
            switch eventCode {
            case .hasBytesAvailable:
                var data = Data()
                guard let inputStream = inputStream,
                      inputStream.read(data: &data) > 0,
                      let message = String(data: data, encoding: .utf8)
                else { return }
                
                if let receivedMessage = StreamData.receiveMessage(message) {
                    delegate?.receive(chat: receivedMessage)
                    return
                }
                
            default: break
            }
        }
    }
}

extension OutputStream {
    @discardableResult
    func write(data: Data) -> Int {
        let count = data.count
        return data.withUnsafeBytes {
            return write($0.bindMemory(to: UInt8.self).baseAddress!, maxLength: count)
        }
    }
}

extension InputStream {
    private var maxLength: Int { 4096 }
    
    func read(data: inout Data) -> Int {
        var totalReadCount: Int = 0
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxLength)
        while hasBytesAvailable {
            let numberOfBytesRead = read(buffer, maxLength: maxLength)
            if let error = streamError {
                print(error)
                break
            } else if numberOfBytesRead < 0 {
                break
            }
            data.append(buffer, count: numberOfBytesRead)
            totalReadCount += numberOfBytesRead
        }
        return totalReadCount
    }
}
