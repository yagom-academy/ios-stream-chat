//
//  ChatPageDelegate.swift
//  StreamChat
//
//  Created by Fezravien on 2021/08/10.
//

import Foundation

protocol ChatPageDelegate: AnyObject {
    func received(message: ChatMessage)
    func sendButtonTapped(message: String)
}
