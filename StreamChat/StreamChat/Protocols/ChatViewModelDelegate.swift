//
//  Receivable.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/15.
//

import Foundation

protocol ChatViewModelDelegate: AnyObject {
    func chatViewModelWillAppendChatInMessages(_ message: String)
}
