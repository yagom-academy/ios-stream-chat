//
//  StreamChat - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import SnapKit

class ViewController: UIViewController {

    let streamChat = StreamChat(username: "테스트")

    let tableView = UITableView()
    let sendMessageView = SendMessageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupSendMessageView()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MessageCell.self, forCellReuseIdentifier: MessageCell.reuseIfentifier)

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

// MARK: - TableView Delegate
extension ViewController: UITableViewDelegate {

}

// MARK: - TableView DataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return streamChat.countChats()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.reuseIfentifier,
                                                       for: indexPath) as? MessageCell else { return UITableViewCell() }

        let chat = streamChat.readChats(at: indexPath.row)
        if chat.isSendMessage {
            cell.setupSendMessage(message: chat.message, time: chat.date)
        } else {
            cell.setupReceiveMessage(message: chat.message, time: chat.date, username: chat.username)
        }

        return cell
    }
}

protocol ViewControllerDelegate {
    func sendMessage(message: String)
}

extension ViewController: ViewControllerDelegate {
    func sendMessage(message: String) {
        streamChat.sendChat(message: message)
        tableView.reloadData()
    }
}
