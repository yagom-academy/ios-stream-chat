//
//  StreamChat - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import SnapKit

final class StreamChatViewController: UIViewController {

    private let tableView = UITableView()
    private let sendMessageView = SendMessageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        StreamChat.shared.delegate = self
        setupTableView()
        setupSendMessageView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        StreamChat.shared.stopChat()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.register(MyMessageCell.self, forCellReuseIdentifier: MyMessageCell.reuseIfentifier)
        tableView.register(OtherMessageCell.self, forCellReuseIdentifier: OtherMessageCell.reuseIdentifier)
        tableView.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.reuseIdentifier)

        tableView.backgroundColor = .systemBackground
        tableView.snp.makeConstraints { tableView in
            tableView.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func setupSendMessageView() {
        view.addSubview(sendMessageView)

        sendMessageView.delegate = self
        sendMessageView.snp.makeConstraints { sendView in
            sendView.height.equalTo(70)
            sendView.top.equalTo(tableView.snp.bottom)
            sendView.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

}

// MARK: - TableView DataSource
extension StreamChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StreamChat.shared.countChats()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = StreamChat.shared.readChats(at: indexPath.row)

        switch chat.identifier {
        case .my:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: MyMessageCell.reuseIfentifier,
                    for: indexPath) as? MyMessageCell else { return UITableViewCell() }
            cell.setupMessage(message: chat.message, time: chat.date)

            return cell
        case .other:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: OtherMessageCell.reuseIdentifier,
                    for: indexPath) as? OtherMessageCell else { return UITableViewCell() }
            cell.setupMessage(message: chat.message, time: chat.date, username: chat.username)

            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: NotificationCell.reuseIdentifier,
                    for: indexPath) as? NotificationCell else { return UITableViewCell() }
            cell.setupNotificationLabel(message: chat.message)
            return cell
        }
    }
}

protocol StreamChatDelegate {
    func sendMessage(message: String)

    func receiveMessage()
}

extension StreamChatViewController: StreamChatDelegate {
    func sendMessage(message: String) {
        StreamChat.shared.sendChat(message: message)

        let lastRow: Int = StreamChat.shared.countChats() - 1
        let indexPath: IndexPath = IndexPath(row: lastRow, section: 0)
        tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.none)
        tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
    }

    func receiveMessage() {
        let lastRow: Int = StreamChat.shared.countChats() - 1
        let indexPath: IndexPath = IndexPath(row: lastRow, section: 0)
        tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.none)
        tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
    }
}
