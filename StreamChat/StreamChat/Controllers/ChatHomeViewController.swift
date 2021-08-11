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
        button.isEnabled = false
        button.backgroundColor = .systemGray3
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private var chatUserNameTextFieldConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewController()
        setDelegate()
        setKeyboardObserver()
        setConstraint()
    }
    
    private func setDelegate() {
        self.chatUsernameTextField.delegate = self
    }
    
    private func setViewController() {
        self.navigationController?.isToolbarHidden = true
        self.view.backgroundColor = .white
    }
    
    private func setKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let endFrameValue = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue) else {
            
            return
        }
        
        NSLayoutConstraint.deactivate([ self.chatUserNameTextFieldConstraint ])
        
        let endFrame = endFrameValue.cgRectValue
        self.chatUserNameTextFieldConstraint = self.chatUsernameTextField.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,
                                                                                          constant: -(endFrame.size.height + self.chatUsernameTextField.frame.height * 2))
        NSLayoutConstraint.activate([ self.chatUserNameTextFieldConstraint ])
        
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        NSLayoutConstraint.deactivate([ self.chatUserNameTextFieldConstraint ])
        self.chatUserNameTextFieldConstraint = self.chatUsernameTextField.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,
                                                                                          constant: -220)
        NSLayoutConstraint.activate([ self.chatUserNameTextFieldConstraint ])

        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
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
        self.chatUserNameTextFieldConstraint = self.chatUsernameTextField.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -220)
        NSLayoutConstraint.activate([
            self.chatUserNameTextFieldConstraint,
            self.chatUsernameTextField.centerXAnchor.constraint(equalTo: self.chatLogoImageView.centerXAnchor),
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

extension ChatHomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.chatUsernameTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let textField = chatUsernameTextField.text else { return }
        if !textField.isEmpty {
            self.chatJoinButton.isEnabled = true
            self.chatJoinButton.backgroundColor = .systemOrange
        } else {
            self.chatJoinButton.isEnabled = false
            self.chatJoinButton.backgroundColor = .systemGray3
        }
    }
}
