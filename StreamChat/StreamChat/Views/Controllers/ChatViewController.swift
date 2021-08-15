//
//  StreamChat - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ChatViewController: UIViewController {
    
    let chatViewModel = ChatViewModel()
    private var typingContainerViewBottomConstraints: NSLayoutConstraint = NSLayoutConstraint()
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
    
    private lazy var messageSendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .yellow
        button.setImage(UIImage(systemName: "shift.fill"), for: .normal)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(sendButton), for: .touchDown)
        return button
    }()
    
    // MARK: ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setNotificationCenter()
        setDataBindingWithViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        chatViewModel.send(message: StreamData.leaveMessage)
        chatViewModel.closeStreamTask()
        chatViewModel.networkManager.connectServer()
        chatViewModel.resetMessages()
    }
    
    // MARK: NotificationCenter
    
    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notification) in
            guard let userInfo = notification.userInfo else { return }
            guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
            self.typingContainerViewBottomConstraints.constant = -keyboardFrame.height
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
                self.scrollTableViewToBottom()
            }
        }
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (notification) in
            guard let userInfo = notification.userInfo else { return }
            guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
            self.typingContainerViewBottomConstraints.constant = 0
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
                self.scrollTableViewToBottom()
            }
        }
    }
    
    // MARK: UI Setting
    
    private func setUI() {
        addAllSubviews()
        setChatTableView()
        setNavigationBar()
        setTypingContainerView()
        setTypingTextField()
        setMessageSendButton()
    }
    
    private func addAllSubviews() {
        self.view.addSubview(chatTableView)
        self.view.addSubview(typingContainerView)
        self.typingContainerView.addSubview(typingTextField)
        self.typingContainerView.addSubview(messageSendButton)
    }
    
    private func setNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .darkGray
        self.navigationController?.navigationBar.tintColor = .yellow
    }
    
    private func setChatTableView() {
        chatTableView.dataSource = self
        chatTableView.delegate = self
        chatTableView.register(MyChatTableViewCell.self, forCellReuseIdentifier: MyChatTableViewCell.identifier)
        chatTableView.register(OtherChatTableViewCell.self, forCellReuseIdentifier: OtherChatTableViewCell.identifier)
        chatTableView.register(AlertTableViewCell.self, forCellReuseIdentifier: AlertTableViewCell.identifier)
        chatTableView.keyboardDismissMode = .onDrag
        setConstraintOfChatTableView()
    }
    
    private func setTypingContainerView() {
        typingContainerView.backgroundColor = .darkGray
        setConstraintOfTypingContainerView()
    }
    
    private func setTypingTextField() {
        typingTextField.backgroundColor = .systemGray
        typingTextField.layer.cornerRadius = 10
        setConstraintOfTypingTextField()
    }
    
    private func setMessageSendButton() {
        messageSendButton.layer.cornerRadius = 10
        messageSendButton.backgroundColor = .yellow
        messageSendButton.tintColor = .darkGray
        setConstraintOfMessageSendButton()
    }
    
    // MARK: Constraints Setting
    
    private func setConstraintOfChatTableView() {
        NSLayoutConstraint.activate([
            chatTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            chatTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            chatTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
            
        ])
    }
    
    private func setConstraintOfTypingContainerView() {
        typingContainerViewBottomConstraints = typingContainerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        NSLayoutConstraint.activate([typingContainerView.topAnchor.constraint(equalTo: self.chatTableView.bottomAnchor, constant: 0),
                                     typingContainerView.heightAnchor.constraint(equalToConstant: 70),
                                     typingContainerView.widthAnchor.constraint(equalTo: self.view.widthAnchor)])
        typingContainerViewBottomConstraints.isActive = true
    }
    
    private func setConstraintOfTypingTextField() {
        NSLayoutConstraint.activate([
            typingTextField.topAnchor.constraint(equalTo: self.typingContainerView.topAnchor, constant: 10),
            typingTextField.leadingAnchor.constraint(equalTo: self.typingContainerView.leadingAnchor, constant: 10),
            typingTextField.bottomAnchor.constraint(equalTo: self.typingContainerView.bottomAnchor, constant: -20),
            typingTextField.trailingAnchor.constraint(equalTo: self.typingContainerView.trailingAnchor, constant: -70)
        ])
    }
    
    private func setConstraintOfMessageSendButton() {
        NSLayoutConstraint.activate([
            messageSendButton.topAnchor.constraint(equalTo: self.typingContainerView.topAnchor, constant: 10),
            messageSendButton.leadingAnchor.constraint(equalTo: self.typingTextField.trailingAnchor, constant: 10),
            messageSendButton.bottomAnchor.constraint(equalTo: self.typingTextField.bottomAnchor),
            messageSendButton.trailingAnchor.constraint(equalTo: self.typingContainerView.trailingAnchor, constant: -15)
        ])
    }
    
    // MARK: Send Button Action
    
    @objc func sendButton() {
        guard let text = typingTextField.text, text.isEmpty == false else { return }
        chatViewModel.insertMessage(chat: Chat(senderType: Identifier.userSelf, senderName: "userSelf", message: text, date: Date()))
        typingTextField.text = nil
    }
    
    // MARK: Data Binding
    
    private func setDataBindingWithViewModel() {
        chatViewModel.onUpdated = { [weak self] newMessages, oldMessages in
            guard let self = self else { return }
            let indexPath = IndexPath(row: newMessages.count - 1, section: .zero)
            
            if newMessages.count - oldMessages.count == 1 {
                self.chatTableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.none)
                self.scrollTableViewToBottom()
                return
            }
            
            self.chatTableView.reloadData()
            self.scrollTableViewToBottom()
        }
    }
    
    private func scrollTableViewToBottom() {
        guard chatViewModel.getCountOfMessages() > 0 else { return }
        self.chatTableView.scrollToRow(at: IndexPath(row: chatViewModel.getCountOfMessages()-1, section: .zero),
                                       at: .bottom,
                                       animated: true)
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatViewModel.getCountOfMessages()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatInformation = chatViewModel.getMessage(indexPath: indexPath)
        switch chatInformation.senderType {
        case .userSelf:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyChatTableViewCell.identifier, for: indexPath) as? MyChatTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(chatInformation: chatInformation)
            return cell
        case .otherUser:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: OtherChatTableViewCell.identifier, for: indexPath) as? OtherChatTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(chatInformation: chatInformation)
            return cell
        case .chatManager:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AlertTableViewCell.identifier, for: indexPath) as? AlertTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(chatInformation: chatInformation)
            return cell
        }
    }
    
}

extension ChatViewController: UITableViewDelegate {

}
