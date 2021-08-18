//
//  MockNetworkManager.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/17.
//

import Foundation

class MockNetworkManager: NetworkManagerProtocol {
    weak var delegate: ChatViewModelDelegate?
    
    func setUrlSessionStreamDelegate(inputStream: InputStreamProtocol,
                                     outputStream: outputStreamProtocol) {
        
    }
    
    func connectServer() {
        
    }

    func send(message: String) {
        
    }

    func closeStreamTask() {
        
    }
}
