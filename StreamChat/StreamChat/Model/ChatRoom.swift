//
//  ChatRoom.swift
//  StreamChat
//
//  Created by James on 2021/08/12.
//

import UIKit

final class ChatRoom: NSObject {
    
    // MARK: - Properties
    
    var urlSession: URLSession
    var streamTask: URLSessionStreamTask?
    var inputStream: InputStream?
    var outputStream: OutputStream?
    let maxReadLength = 2400
    var username = ""
    
    // MARK: - Methods
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
        }
    private func setUpNetwork() {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: .main)
        streamTask = urlSession.streamTask(withHostName: StreamInformation.host, port: StreamInformation.portNumber)
        streamTask?.startSecureConnection()
        streamTask?.resume()
        streamTask?.captureStreams()
    }
    func joinChat(username: String) {
        guard let data = "USR_NAME::\(username)::END".data(using: .utf8) else {
            return
        }
        data.withUnsafeBytes { unsafeRawBufferPointer in
            guard let pointer = unsafeRawBufferPointer.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                return

            }
            outputStream?.write(pointer, maxLength: data.count)
        }
    }
    private func readAvailableBytes(stream: InputStream) {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxReadLength)
        while stream.hasBytesAvailable {
            let numberOfBytesRead = stream.read(buffer, maxLength: maxReadLength)
            if numberOfBytesRead < 0 {
                if let error = stream.streamError {
                    NSLog(error.localizedDescription)
                    break
                }
            }
        }
    }
    func send(_ message: String) {
        guard let data = "MSG::\(message)::END".data(using: .utf8) else {
            return
            
        }
        data.withUnsafeBytes { unsafeRawBufferPointer in
            guard let pointer = unsafeRawBufferPointer.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                return
            }
            outputStream?.write(pointer, maxLength: data.count)
        }
    }
}

// MARK: - StreamDelegate

extension ChatRoom: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
      switch eventCode {
      case .hasBytesAvailable:
        print("new message received")
      case .endEncountered:
        print("new message received")
      case .errorOccurred:
        print("error occurred")
      case .hasSpaceAvailable:
        print("has space available")
      default:
        print("some other event...")
      }
}
}

// MARK: - URLSessionStreamDelegate

extension ChatRoom: URLSessionStreamDelegate {
    func urlSession(_ session: URLSession, streamTask: URLSessionStreamTask, didBecome inputStream: InputStream, outputStream: OutputStream) {

        self.inputStream = inputStream
        self.inputStream?.delegate = self
        self.outputStream = outputStream
        self.outputStream?.delegate = self
        self.inputStream?.schedule(in: .main, forMode: .default)
        self.outputStream?.schedule(in: .main, forMode: .default)
        self.inputStream?.open()
        self.outputStream?.open()
    }
}
