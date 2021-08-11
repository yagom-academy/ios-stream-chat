//
//  ChatRoomViewModel.swift
//  StreamChat
//
//  Created by Ryan-Son on 2021/08/11.
//

import Foundation

final class ChatRoomViewModel {

    // MARK: Data binding

    private var changed: (() -> Void)?

    // MARK: Properties

    private let chatRoom = ChatRoom()
    private var messages: [Message] = [] {
        didSet { changed?() }
    }

    var messageCount: Int {
        messages.count
    }

    // MARK: Initializers

    init() {
        chatRoom.delegate = self
    }

    // MARK: Chat room view model features

    func bind(with changed: @escaping (() -> Void)) {
        self.changed = changed
    }

    func message(at index: Int) -> Message? {
        guard index < messages.count else { return nil }
        return messages[index]
    }

    func send(message: String) {
        let created = createMessage(with: message)
        messages.append(created)
        chatRoom.send(message: message)
    }

    func joinChat(with username: String) {
        chatRoom.connect()
        chatRoom.join(with: username)
    }

    func leaveChat() {
        chatRoom.leave()
        chatRoom.disconnect()
    }

    private func createMessage(with string: String) -> Message {
        return Message(sender: chatRoom.user, text: string, dateTime: Date())
    }
}

// MARK: - ChatRoomDelegate

extension ChatRoomViewModel: ChatRoomDelegate {

    func received(message: Message) {
        messages.append(message)
    }
}
