//
//  ChatHomeViewController.swift
//  StreamChat
//
//  Created by Fezravien on 2021/08/10.
//

import UIKit

class ChatHomeViewController: UIViewController {
    private let chatLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Chat")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private let chatUsernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "아이디를 입력해주세요..."
        textField.font = UIFont.preferredFont(forTextStyle: .headline)
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    private let chatJoinButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.setTitle("JOIN", for: .normal)
        button.backgroundColor = .systemOrange
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isToolbarHidden = true
        self.view.backgroundColor = .white
        setKeyboardObserver()
        setConstraint()
    }
    
    private func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChange(notification: NSNotification) {
        
    }
    
    private func setConstraint() {
        setChatLogImageViewConstraint()
        setChatUsernametextField()
        setJoinButton()
    }
    
    private func setChatLogImageViewConstraint() {
        self.view.addSubview(chatLogoImageView)
        
        NSLayoutConstraint.activate([
            self.chatLogoImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.chatLogoImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -180),
            self.chatLogoImageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 5/6),
            self.chatLogoImageView.heightAnchor.constraint(equalTo: self.chatLogoImageView.widthAnchor, multiplier: 3/4)
        ])
    }
    
    private func setChatUsernametextField() {
        self.view.addSubview(chatUsernameTextField)
        
        NSLayoutConstraint.activate([
            self.chatUsernameTextField.centerXAnchor.constraint(equalTo: self.chatLogoImageView.centerXAnchor),
            self.chatUsernameTextField.topAnchor.constraint(equalTo: self.chatLogoImageView.bottomAnchor, constant: 150),
            self.chatUsernameTextField.widthAnchor.constraint(equalTo: self.chatLogoImageView.widthAnchor, multiplier: 3/7, constant: 15)
        ])
    }
    
    private func setJoinButton() {
        self.view.addSubview(chatJoinButton)
        
        NSLayoutConstraint.activate([
            self.chatJoinButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.chatJoinButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            self.chatJoinButton.widthAnchor.constraint(equalTo: chatUsernameTextField.widthAnchor, multiplier: 3/5)
        ])
    }

}
