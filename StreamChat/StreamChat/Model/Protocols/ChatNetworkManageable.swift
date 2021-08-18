//
//  ChatNetworkManageable.swift
//  StreamChat
//
//  Created by James on 2021/08/17.
//

import Foundation

protocol ChatNetworkManageable: AnyObject {
    
    func setUpNetwork()
    func read(completionHandler: @escaping (Result<Data, NetworkError>) -> Void)
    func write(data: Data)
    func closeStream()
}
