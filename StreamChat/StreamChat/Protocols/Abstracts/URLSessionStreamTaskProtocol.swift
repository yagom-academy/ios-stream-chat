//
//  URLSessionStreamTaskProtocol.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/18.
//

import Foundation

protocol URLSessionStreamTaskProtocol {
    func resume()
    
    func captureStreams()
    
    func closeRead()
    
    func closeWrite()
}

extension URLSessionStreamTask: URLSessionStreamTaskProtocol {
}
