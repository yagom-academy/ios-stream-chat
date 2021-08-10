//
//  LoginViewController.swift
//  StreamChat
//
//  Created by Ryan-Son on 2021/08/11.
//

import UIKit

final class JoinChatRoomViewController: UIViewController {

    private enum Style {

        static let navigationBarTitle: String = "Sign in"

        enum WelcomeLabel {
            static let welcomeLabelText: String = "Welcome!"
        }

        enum UsernameTextField {
            static let placeholderText: String = "Please enter your name..."
            static let borderWidth: CGFloat = 1
        }

        enum ContentStackView {
            static let spacing: CGFloat = 80
        }
    }

    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = Style.WelcomeLabel.welcomeLabelText
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textAlignment = .center
        return label
    }()

    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Style.UsernameTextField.placeholderText
        textField.font = UIFont.preferredFont(forTextStyle: .title3)
        textField.textAlignment = .center
        textField.backgroundColor = .systemGray6
        textField.borderStyle = .roundedRect
        return textField
    }()

    let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = Style.ContentStackView.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        setNavigationBar()
        setAttributes()
        addSubviews()
        setUpConstraints()
    }

    private func setAttributes() {
        view.backgroundColor = .systemBackground
    }

    private func setNavigationBar() {
        title = Style.navigationBarTitle
    }

    private func addSubviews() {
        contentStackView.addArrangedSubview(welcomeLabel)
        contentStackView.addArrangedSubview(usernameTextField)
        view.addSubview(contentStackView)
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            contentStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentStackView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor),
            contentStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension JoinChatRoomViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let chatRoomViewController = ChatRoomViewController()
        if let username = textField.text {
            chatRoomViewController.join(with: username)
        }
        navigationController?.pushViewController(chatRoomViewController, animated: true)
        return true
    }
}
