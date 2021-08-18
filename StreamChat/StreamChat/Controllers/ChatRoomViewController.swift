//
//  ChatRoomViewController.swift
//  StreamChat
//
//  Created by James on 2021/08/17.
//

import UIKit

class ChatRoomViewController: UIViewController {
    
    // MARK: - Properties
    
    var myUserName = ""
    private var chatList: [Message] = []
    private let chatRoom = ChatRoom(chatNetworkManager: ChatNetworkManager())
    private var bottomConstraint: NSLayoutConstraint?
    
    // MARK: - Views
    
    private let chatMessageView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(OthersMessageViewCell.self, forCellReuseIdentifier: OthersMessageViewCell.identifier)
        tableView.register(MyMessageViewCell.self, forCellReuseIdentifier: MyMessageViewCell.identifier)
        tableView.keyboardDismissMode = .interactive
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        return tableView
    }()
    
    private let messageInputView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private let messageInputTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textField.backgroundColor = .systemGray5
        textField.autocorrectionType = .no
        return textField
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGreen
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        button.setTitle("send", for: .normal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        return button
    }()
    
    private lazy var messageInputStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [ messageInputTextField, sendButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    // MARK: - Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chatRoom.joinChat(username: myUserName)
        chatRoom.receiveChat()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        chatRoom.leaveChat()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpChatRoomView()
        chatMessageView.dataSource = self
        chatRoom.delegate = self
        changeLayoutWhenKeyboardShowsAndHides()
    }
    
    private func changeLayoutWhenKeyboardShowsAndHides() {
        NotificationCenter.default.addObserver(self, selector: #selector(setViewLayoutWhenKeyboardShows), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setViewLayoutWhenKeyboardHides), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func setViewLayoutWhenKeyboardShows(_ notification: Notification) {
        
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        bottomConstraint?.constant = -keyboardFrame.height - 8
        
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
            self.scrollToLastChat()
        }
    }
    
    @objc private func setViewLayoutWhenKeyboardHides(_ notification: Notification) {
        
        guard let userInfo = notification.userInfo else { return }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        
        bottomConstraint?.constant = -8
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc private func sendMessage(_ sender: UIButton) {
        guard let text = messageInputTextField.text,
              text.isEmpty == false else { return }
        chatList.append(Message(content: text, senderUsername: "\(self.myUserName):", messageSender: .myself))
        chatRoom.send(text)
        messageInputTextField.text = nil
        
        let indexPath = IndexPath(row: chatList.count - 1, section: 0)
        
        chatMessageView.insertRows(at: [indexPath], with: .none)
        chatMessageView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    private func scrollToLastChat() {
        guard !chatList.isEmpty else { return }
        
        let lastIndex = IndexPath(row: chatList.count - 1, section: 0)
        
        chatMessageView.scrollToRow(at: lastIndex, at: .bottom, animated: true)
        
    }
    
    private func setUpChatRoomView() {
        navigationItem.title = "개울챗"
        self.view.addSubview(messageInputView)
        messageInputView.addSubview(messageInputStackView)
        self.view.addSubview(chatMessageView)
        
        NSLayoutConstraint.activate([
            messageInputView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            messageInputView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            messageInputView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            
            messageInputStackView.topAnchor.constraint(equalTo: messageInputView.topAnchor, constant: 5),
            messageInputStackView.leadingAnchor.constraint(equalTo: messageInputView.leadingAnchor, constant: 5),
            messageInputStackView.trailingAnchor.constraint(equalTo: messageInputView.trailingAnchor, constant: -5)
            
        ])
        bottomConstraint =
            messageInputStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        bottomConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            chatMessageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            chatMessageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            chatMessageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            chatMessageView.bottomAnchor.constraint(equalTo: self.messageInputView.topAnchor, constant: 10)
        ])
    }
}

// MARK: - ChatReadable

extension ChatRoomViewController: ChatReadable {
    func fetchMessageFromServer(data: Data) {
        guard let decodedMessageStringList = String(data: data, encoding: .utf8)?.components(separatedBy: "::"),
              let userName = decodedMessageStringList.first,
              let content = decodedMessageStringList.last else { return }
        if userName != self.myUserName && decodedMessageStringList.count == 2 {
            receiveMessage(username: "\(userName):", content: content)
        } else if userName != self.myUserName && decodedMessageStringList.count == 1 {
            receiveUserInformationMessage(content: content)
        }
    }
    
    private func receiveMessage(username: String, content: String) {
        guard username.isEmpty == false,
              content.isEmpty == false else { return }
        
        chatList.append(Message(content: content, senderUsername: username, messageSender: .someoneElse))
        
        let indexPath = IndexPath(row: chatList.count - 1, section: 0)
        
        chatMessageView.insertRows(at: [indexPath], with: .none)
        chatMessageView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    private func receiveUserInformationMessage(content: String) {
        guard content.isEmpty == false else { return }
        
        chatList.append(Message(content: content, senderUsername: "", messageSender: .someoneElse))
        
        let indexPath = IndexPath(row: chatList.count - 1, section: 0)
        
        chatMessageView.insertRows(at: [indexPath], with: .none)
        chatMessageView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

// MARK: - UITableViewDataSource

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
            cell.changeLabelText("\(message.senderUsername) \(message.content)")
            return cell
        } else if message.messageSender == .someoneElse {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: messageIdentifier, for: indexPath) as? OthersMessageViewCell else {
                return UITableViewCell()
            }
            cell.changeLabelText("\(message.senderUsername) \(message.content)")
            return cell
        }
        return UITableViewCell()
        
    }
}
