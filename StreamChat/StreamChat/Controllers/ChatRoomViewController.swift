//
//  ChatRoomViewController.swift
//  StreamChat
//
//  Created by James on 2021/08/17.
//

import UIKit

class ChatRoomViewController: UIViewController {
    
    // MARK: - Properties
    
    var username = ""
    private var chatList: [Message] = []
    private let chatRoom = ChatRoom(chatNetworkManager: ChatNetworkManager())
    
    private let chatMessageView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(OthersMessageViewCell.self, forCellReuseIdentifier: OthersMessageViewCell.identifier)
        tableView.register(MyMessageViewCell.self, forCellReuseIdentifier: MyMessageViewCell.identifier)
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }()
    
    private let messageInputView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }()
    
    private let messageInputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textField.backgroundColor = .white
        return textField
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .brown
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        button.setTitle("전송", for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chatRoom.joinChat(username: username)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        chatRoom.leaveChat()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpChatRoomView()
        chatMessageView.dataSource = self
        changeLayoutWhenKeyboardShowsAndHides()
    }
    
    private func changeLayoutWhenKeyboardShowsAndHides() {
        NotificationCenter.default.addObserver(self, selector: #selector(setViewLayoutWhenKeyboardShows), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setViewLayoutWhenKeyboardHides), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func setViewLayoutWhenKeyboardShows(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        if self.view.bounds.origin.y == 0 {
            self.view.bounds.origin.y += keyboardFrame.height
        }
        
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func setViewLayoutWhenKeyboardHides(_ notification: Notification) {
        if self.view.bounds.origin.y != 0 {
            self.view.bounds.origin.y = 0
        }
    }
    
    @objc private func sendMessage(_ sender: UIButton) {
        guard let text = messageInputTextField.text,
              text.isEmpty == false else { return }
        chatList.append(Message(content: text, senderUsername: self.username, messageSender: .myself))
        chatRoom.send(text)
        messageInputTextField.text = nil
        
        let indexPath = IndexPath(row: chatList.count - 1, section: 0)
        
        chatMessageView.insertRows(at: [indexPath], with: .none)
        chatMessageView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }
    
    private func setUpChatRoomView() {
        self.view.addSubview(messageInputView)
        messageInputView.addSubview(messageInputTextField)
        messageInputView.addSubview(sendButton)
        self.view.addSubview(chatMessageView)
        
        NSLayoutConstraint.activate([
            messageInputView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            messageInputView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            messageInputView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            messageInputTextField.topAnchor.constraint(equalTo: messageInputView.topAnchor, constant: 5),
            messageInputTextField.leadingAnchor.constraint(equalTo: messageInputView.leadingAnchor, constant: 8),
            messageInputTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -5),
            messageInputTextField.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            
            sendButton.topAnchor.constraint(equalTo: messageInputTextField.topAnchor),
            sendButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8),
            sendButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            
            chatMessageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            chatMessageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            chatMessageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            chatMessageView.bottomAnchor.constraint(equalTo: self.messageInputView.topAnchor)
            
        ])
    }
}
extension ChatRoomViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = chatList[indexPath.row]
        let messageIdentifier = message.messageSender == .myself ? MyMessageViewCell.identifier : OthersMessageViewCell.identifier
        if message.messageSender == .myself {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: messageIdentifier, for: indexPath) as? MyMessageViewCell else {
                return UITableViewCell()
            }
            cell.changeLabelText(message.content)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: messageIdentifier, for: indexPath) as? OthersMessageViewCell else {
                return UITableViewCell()
            }
            cell.changeLabelText(message.content)
            return cell
        }
        
    }
}
