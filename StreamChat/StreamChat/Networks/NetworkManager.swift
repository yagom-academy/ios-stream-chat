//
//  NetworkManager.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/12.
//

import UIKit

final class NetworkManager: NSObject {
    private var session: URLSession!
    var inputStream: InputStream?
    private var outputStream: OutputStream?
    private var streamTask: URLSessionStreamTask?
    weak var delegate: ChatViewModelDelegate?
    
    init(configuration: URLSessionConfiguration, delegateQueue: OperationQueue?) {
        super.init()
        session = URLSession.init(configuration: configuration, delegate: self, delegateQueue: delegateQueue)
    }
    
    func connectServer() {
        streamTask = session.streamTask(withHostName: NetworkAddress.ipAddress, port: NetworkAddress.port)
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
        if inputStream == aStream {
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
