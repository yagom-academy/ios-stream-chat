//
//  ChatRoomViewController.swift
//  StreamChat
//
//  Created by 황인우 on 2021/08/17.
//

import UIKit

class ChatRoomViewController: UIViewController {
    
    // MARK: - Properties
    
    var username = ""
    
    private let chatRoom = ChatRoom(chatNetworkManager: ChatNetworkManager())
    
    private let chatMessageView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SenderMessageViewCell.self, forCellReuseIdentifier: SenderMessageViewCell.identifier)
        tableView.register(ReceiverMessageCell.self, forCellReuseIdentifier: ReceiverMessageCell.identifier)
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
