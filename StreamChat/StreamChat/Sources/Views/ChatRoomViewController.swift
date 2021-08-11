//
//  StreamChat - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ChatRoomViewController: UIViewController {

    // MARK: Namespaces

    private enum Style {

        enum NavigationBar {
            static let title: String = "Let's chat!"
        }

        enum Constraint {
            static let contentStackViewBottom: CGFloat = -10
        }
    }

    // MARK: Views

    let messagesTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    let messagesInputBarView = MessageInputBarView()

    // MARK: Properties

    let chatRoomViewModel = ChatRoomViewModel()
    let cellReuseIdentifier = "MessageCell"

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        messagesTableView.dataSource = self
        setUpNavigationBar()
        setUpSubviews()
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

    // MARK: set up views

    private func setUpNavigationBar() {
        title = Style.NavigationBar.title
    }

    private func setUpSubviews() {
        view.addSubview(messagesTableView)
        view.addSubview(messagesInputBarView)
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            messagesInputBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messagesInputBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messagesInputBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            messagesInputBarView.contentStackView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: Style.Constraint.contentStackViewBottom
            )
        ])

        NSLayoutConstraint.activate([
            messagesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            messagesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            messagesTableView.topAnchor.constraint(equalTo: view.topAnchor),
            messagesTableView.bottomAnchor.constraint(equalTo: messagesInputBarView.topAnchor)
        ])
    }

    // MARK: Chat room features

    func join(with username: String) {
        chatRoomViewModel.joinChat(with: username)
    }
}

// MARK: - UITableViewDataSource

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
