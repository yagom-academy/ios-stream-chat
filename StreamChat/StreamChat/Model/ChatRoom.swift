//
//  ChatRoom.swift
//  StreamChat
//
//  Created by James on 2021/08/12.
//

import UIKit

final class ChatRoom: NSObject {
    
    // MARK: - Properties
    var urlSession: URLSessionProtocol
    var streamTask: URLSessionStreamTask?
    var username = ""
    
    // MARK: - Methods
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func setUpNetwork() {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        self.streamTask = urlSession.streamTask(withHostName: StreamInformation.host, port: StreamInformation.portNumber)
        streamTask?.resume()
        read(from: streamTask)
    }
    
    func joinChat(username: String) {
        guard let data = "USR_NAME::\(username)::END".data(using: .utf8) else {
            
            return
        }
        write(data: data)
    }
    
    func send(_ message: String) {
        guard let data = "MSG::\(message)::END".data(using: .utf8) else {
            
            return
        }
        write(data: data)
    }
    
    func closeStream() {
        urlSession.invalidateAndCancel()
    }
    
    private func read(from streamTask: URLSessionStreamTask?) {
        streamTask?.readData(ofMinLength: ConnectionConfiguration.minimumReadLength, maxLength: ConnectionConfiguration.maximumReadLength, timeout: ConnectionConfiguration.timeOut) { [weak self] data, _, error in
            guard let self = self else {
                
                return
            }
            defer {
                self.read(from: streamTask)
            }
            guard let data = data else {
                return
            }
            
            // MARK: - Read Log
            NSLog(String(data: data, encoding: .utf8) ?? "no message could be read")
            
            if let readError = error {
                NSLog(readError.localizedDescription)
            }
        }
    }
    
    private func write(data: Data) {
        streamTask?.write(data, timeout: ConnectionConfiguration.timeOut) { error in
            if let writeError = error {
                NSLog(writeError.localizedDescription)
            }
        }
    }
}

// MARK: - URLSessionStreamDelegate

extension ChatRoom: URLSessionStreamDelegate {
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        streamTask?.closeRead()
        streamTask?.closeWrite()
    }
}
