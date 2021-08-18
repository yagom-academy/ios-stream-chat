//
//  NetworkManager.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/12.
//

import UIKit

final class NetworkManager: NSObject {
    private var inputStream: InputStreamProtocol?
    private var outputStream: outputStreamProtocol?
    private var streamTask: URLSessionStreamTaskProtocol?
    weak var delegate: ChatViewModelDelegate?
    
    init(streamTask: URLSessionStreamTaskProtocol,
         inputStream: InputStreamProtocol,
         outputStream: outputStreamProtocol) {
        self.streamTask = streamTask
        self.inputStream = inputStream
        self.outputStream = outputStream
    }
    
    override init() {
        super.init()
    }
    
    func setStreamTask(_ streamTask: URLSessionStreamTaskProtocol) {
        self.streamTask = streamTask
    }
    
    func connectServer() {
        streamTask?.resume()
        streamTask?.captureStreams()
    }
    
    func send(message: String) {
        guard let data = message.data(using: .utf8) else { return }
        outputStream?.write(data: data)
    }
    
    func closeStreamTask() {
        streamTask?.closeRead()
        streamTask?.closeWrite()
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
        if (aStream as? InputStream) != nil {
            switch eventCode {
            case .hasBytesAvailable:
                var data = Data()
                guard let inputStream = inputStream,
                      inputStream.read(data: &data) > 0,
                      let message = String(data: data, encoding: .utf8)
                else { return }
                delegate?.chatViewModelWillGetReceivedMessage(message)
            default: break
            }
        }
    }
}

extension OutputStream {
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
