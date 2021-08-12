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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    @objc func inputUserName() {
        let chatViewController = ChatViewController()
        guard let textFieldText = userNameTextField.text, textFieldText.count > 0 else { return }
        chatViewController.chatViewModel.send(message: "USR_NAME::{\(textFieldText)}::END")
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
            userNameTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            userNameTextField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
            userNameTextField.widthAnchor.constraint(equalToConstant: 250),
            userNameTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setInputUserNameButton() {
        self.view.addSubview(inputUserNameButton)
        NSLayoutConstraint.activate([
            inputUserNameButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            inputUserNameButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
            inputUserNameButton.leadingAnchor.constraint(equalTo: self.userNameTextField.trailingAnchor, constant: 10),
            inputUserNameButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
