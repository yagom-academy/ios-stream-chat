//
//  ChatViewControllerProtocol.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/16.
//

import UIKit

protocol ChatViewControllerProtocol: UIViewController {
    func connectServer()
    func sendOwnUserName(_ name: String)
    func initalizeOwnUserName(_ name: String)
}

extension ChatViewController: ChatViewControllerProtocol {
}
