//
//  Service.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/13.
//

import Foundation

struct Service {
    let networkManager = NetworkManager()
    
    func send(message: String) {
        networkManager.send(message: message)
    }
}
