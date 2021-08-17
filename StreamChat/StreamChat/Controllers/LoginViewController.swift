//
//  StreamChat - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - properties
    
    private let streamImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "stream")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let loginView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let loginTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your nickname"
        textField.backgroundColor = .white
        textField.font = UIFont.preferredFont(forTextStyle: .title1)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        loginTextField.delegate = self
    }
    
    private func setUpViews() {
        navigationItem.title = "개울챗!"
        self.view.backgroundColor = .white
        self.view.addSubview(loginView)
        loginView.addSubview(loginTextField)
        self.view.addSubview(streamImageView)
        
        NSLayoutConstraint.activate([
            loginView.heightAnchor.constraint(greaterThanOrEqualToConstant: self.view.bounds.height / 6),
            loginView.widthAnchor.constraint(equalToConstant: self.view.bounds.width),
            loginView.topAnchor.constraint(equalTo: self.view.topAnchor),
            loginView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            loginView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            loginView.bottomAnchor.constraint(equalTo: streamImageView.topAnchor),
            
            loginTextField.topAnchor.constraint(equalTo: loginView.topAnchor, constant: 10),
            loginTextField.leadingAnchor.constraint(equalTo: loginView.leadingAnchor, constant: 10),
            loginTextField.trailingAnchor.constraint(equalTo: loginView.trailingAnchor, constant: -10),
            loginTextField.bottomAnchor.constraint(equalTo: loginView.bottomAnchor, constant: 10),
            
            streamImageView.heightAnchor.constraint(greaterThanOrEqualToConstant: self.view.bounds.height / 3),
            streamImageView.widthAnchor.constraint(greaterThanOrEqualToConstant: self.view.bounds.width / 2),
            streamImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            streamImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            streamImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10)
        ])
    }
}
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let chatRoomViewController = ChatRoomViewController()
        if let userName = loginTextField.text {
            chatRoomViewController.username = userName
        }
        navigationController?.pushViewController(chatRoomViewController, animated: false)
        return true
    }
}
