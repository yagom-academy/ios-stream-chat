//
//  Receivable.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/15.
//

protocol ChatViewModelDelegate: AnyObject {
    func chatViewModelWillGetReceivedMessage(_ message: String)
}
