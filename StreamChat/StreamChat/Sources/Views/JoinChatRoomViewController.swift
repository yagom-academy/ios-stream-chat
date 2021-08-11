//
//  LoginViewController.swift
//  StreamChat
//
//  Created by Ryan-Son on 2021/08/11.
//

import UIKit

final class JoinChatRoomViewController: UIViewController {

    // MARK: Namespaces

    private enum Style {

        enum NavigationBar {
            static let title: String = "Sign in"
        }

        enum WelcomeLabel {
            static let welcomeLabelText: String = "Welcome!"
            static let font: UIFont.TextStyle = .largeTitle
        }

        enum UsernameTextField {
            static let placeholderText: String = "Please enter your name..."
            static let borderWidth: CGFloat = 1
            static let font: UIFont.TextStyle = .title3
            static let backgroundColor: UIColor = .systemGray6
        }

        enum ContentStackView {
            static let spacing: CGFloat = 80
        }

        enum Constraint {
            static let centerYAgainstViewSafeArea: CGFloat = -100
        }
    }

    // MARK: Views

    let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = Style.ContentStackView.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = Style.WelcomeLabel.welcomeLabelText
        label.font = UIFont.preferredFont(forTextStyle: Style.WelcomeLabel.font)
        label.textAlignment = .center
        return label
    }()

    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Style.UsernameTextField.placeholderText
        textField.font = UIFont.preferredFont(forTextStyle: Style.UsernameTextField.font)
        textField.backgroundColor = Style.UsernameTextField.backgroundColor
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        return textField
    }()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        setUpNavigationBar()
        setAttributes()
        setUpSubviews()
        setUpConstraints()
    }

    // MARK: Set up views

    private func setAttributes() {
        view.backgroundColor = .systemBackground
    }

    private func setUpNavigationBar() {
        title = Style.NavigationBar.title
    }

    private func setUpSubviews() {
        contentStackView.addArrangedSubview(welcomeLabel)
        contentStackView.addArrangedSubview(usernameTextField)
        view.addSubview(contentStackView)
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor,
                                                      constant: Style.Constraint.centerYAgainstViewSafeArea)
        ])
    }
}

// MARK: - UITextFieldDelegate

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
