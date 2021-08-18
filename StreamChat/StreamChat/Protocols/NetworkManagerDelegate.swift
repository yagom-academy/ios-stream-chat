//
//  Receivable.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/15.
//

protocol NetworkManagerDelegate: AnyObject {
    func chatViewModelWillGetReceivedMessage(_ message: String)
}
