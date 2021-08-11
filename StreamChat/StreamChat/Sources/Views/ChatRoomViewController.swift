//
//  StreamChat - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ChatRoomViewController: UIViewController {

    private enum Style {

        static let navigationBarTitle: String = "Let's chat!"
    }

    let messagesTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    let chatRoomViewModel = ChatRoomViewModel()
    let cellReuseIdentifier = "MessageCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        messagesTableView.dataSource = self
        setUpNavigationBar()
        addSubviews()
        setUpConstraints()

        chatRoomViewModel.bind { [weak self] in
            guard let self = self else { return }
            let lastIndexPath = IndexPath(row: self.chatRoomViewModel.messageCount - 1, section: .zero)
            self.messagesTableView.insertRows(at: [lastIndexPath], with: .left)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        chatRoomViewModel.leaveChat()
    }

    func join(with username: String) {
        chatRoomViewModel.joinChat(with: username)
    }

    private func setUpNavigationBar() {
        title = Style.navigationBarTitle
    }

    private func addSubviews() {
        view.addSubview(messagesTableView)
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            messagesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messagesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messagesTableView.topAnchor.constraint(equalTo: view.topAnchor),
            messagesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension ChatRoomViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRoomViewModel.messageCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
            ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellReuseIdentifier)
        let message = chatRoomViewModel.message(at: indexPath.row)
        messageCell.textLabel?.text = message?.sender.name
        messageCell.detailTextLabel?.text = message?.text
        return messageCell
    }
}
