//
//  ChatNetworkManageable.swift
//  StreamChat
//
//  Created by James on 2021/08/17.
//

import Foundation

protocol ChatNetworkManageable: AnyObject {
    func setUpNetwork()
    func read(from streamTask: URLSessionStreamTask?)
    func write(data: Data)
    func closeStream()
}
