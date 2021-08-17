//
//  NetworkManagerProtocol.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/17.
//

import Foundation

protocol NetworkManagerProtocol {
    var delegate: ChatViewModelDelegate? { get set }
    
    func connectServer()
    
    func send(message: String)
    
    func closeStreamTask()
}

extension NetworkManager: NetworkManagerProtocol {
}
