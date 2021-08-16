//
//  UserNameInputViewController.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/13.
//

import UIKit

final class UserNameInputViewController: UIViewController {
    private let chatViewController: ChatViewControllerProtocol
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
    
    // MARK: Initializer
    
    init(chatViewController: ChatViewControllerProtocol) {
        self.chatViewController = chatViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: ViewLifCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        chatViewController.connectServer()
    }
    
    @objc func inputUserName() {
        guard let textFieldText = userNameTextField.text, textFieldText.count > 0 else { return }
        
        chatViewController.initalizeOwnUserName(textFieldText)
        chatViewController.sendOwnUserName(textFieldText)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.pushViewController(self.chatViewController, animated: true)
    }
    
    // MARK: UI Setting
    
    private func setUI() {
        self.view.backgroundColor = .white
        addAllSubviews()
        setNavigationBar()
        setConstraintOfUserNameTextField()
        setConstraintOfInputUserNameButton()
    }
    
    private func addAllSubviews() {
        self.view.addSubview(userNameTextField)
        self.view.addSubview(inputUserNameButton)
    }
    
    private func setNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: Set Constraints
    
    private func setConstraintOfUserNameTextField() {
        NSLayoutConstraint.activate([
            userNameTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            userNameTextField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
            userNameTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.65),
            userNameTextField.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.07)
        ])
    }
    
    private func setConstraintOfInputUserNameButton() {
        NSLayoutConstraint.activate([
            inputUserNameButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            inputUserNameButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0),
            inputUserNameButton.leadingAnchor.constraint(equalTo: self.userNameTextField.trailingAnchor, constant: 10),
            inputUserNameButton.heightAnchor.constraint(equalTo: self.userNameTextField.heightAnchor)
        ])
    }
}
