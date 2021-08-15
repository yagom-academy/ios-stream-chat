//
//  Receivable.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/15.
//

import Foundation

protocol Receivable: AnyObject {
    func receive(chat: Chat)
}
