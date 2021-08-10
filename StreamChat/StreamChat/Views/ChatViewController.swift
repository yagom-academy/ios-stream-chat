//
//  StreamChat - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ChatViewController: UIViewController {
    
    private let chatViewModel = ChatViewModel()
    
    private let chatTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.backgroundColor = .darkGray
        return tableView
    }()
    
    private let typingContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .darkGray
        return view
    }()
    
    private let typingTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemGray2
        return textField
    }()
    
    private let messageSendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .yellow
        button.setImage(UIImage(systemName: "shift.fill"), for: .normal)
        button.tintColor = .darkGray
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    private func setUI() {
        setChatTableView()
        setNavigationBar()
    }
    
    private func setNavigationBar() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .darkGray
    }
    
    private func setChatTableView() {
        self.view.addSubview(chatTableView)
        chatTableView.dataSource = self
        chatTableView.delegate = self
        chatTableView.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.identifier)
        setConstraintOfChatTableView()
    }
    
    private func setConstraintOfChatTableView() {
        NSLayoutConstraint.activate([
            chatTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            chatTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            chatTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            chatTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        ])
    }

}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatViewModel.getCountOfMessages() + 300
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identifier, for: indexPath) as? ChatTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(chatInformation: Chat(message: "hellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohello", isMyMessage: Bool.random()))
        return cell
    }
    
}

extension ChatViewController: UITableViewDelegate {

}
