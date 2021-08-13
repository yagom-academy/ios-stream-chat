//
//  UserNameInputViewController.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/13.
//

import UIKit

class UserNameInputViewController: UIViewController {

    private let userNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = " 사용자 이름을 입력하시오."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderWidth = 0.1
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    private lazy var inputUserNameButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        button.setTitle("입력", for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(inputUserName), for: .touchDown)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let chatViewController = ChatViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        chatViewController.chatViewModel.networkManager.connectServer()
    }
    
    @objc func inputUserName() {
        guard let textFieldText = userNameTextField.text, textFieldText.count > 0 else { return }
        self.chatViewController.chatViewModel.send(message: StreamData.joinTheChat(userName: textFieldText))
        self.navigationController?.navigationBar.isHidden = false
        navigationController?.pushViewController(chatViewController, animated: true)
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        setNavigationBar()
        setUserNameTextField()
        setInputUserNameButton()
    }
    
    private func setNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setUserNameTextField() {
        self.view.addSubview(userNameTextField)
        NSLayoutConstraint.activate([
            userNameTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            userNameTextField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
            userNameTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.65),
            userNameTextField.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.07)
        ])
    }
    
    private func setInputUserNameButton() {
        self.view.addSubview(inputUserNameButton)
        NSLayoutConstraint.activate([
            inputUserNameButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            inputUserNameButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
            inputUserNameButton.leadingAnchor.constraint(equalTo: self.userNameTextField.trailingAnchor, constant: 10),
            inputUserNameButton.heightAnchor.constraint(equalTo: self.userNameTextField.heightAnchor)
        ])
    }
}
