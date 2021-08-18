//
//  StreamChatJoinViewController.swift
//  StreamChat
//
//  Created by 기원우 on 2021/08/17.
//

import UIKit
import SnapKit

final class StreamChatJoinViewController: UIViewController {
    let streamChatViewController = StreamChatViewController()

    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray4
        textField.leftView = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: 10,
                                                  height: textField.frame.height))
        textField.leftViewMode = .always
        return textField
    }()

    private let joinButton: UIButton = {
        let button = UIButton()
        button.setTitle("Join", for: .normal)
        button.backgroundColor = .systemBackground
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapJoinButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "스트림 채팅 입장"
        view.backgroundColor = .systemBackground

        view.addSubview(usernameTextField)
        usernameTextField.snp.makeConstraints { textField in
            textField.centerY.equalTo(view.safeAreaLayoutGuide)
            textField.leading.equalTo(view.safeAreaLayoutGuide).inset(30)
            textField.width.lessThanOrEqualTo(300)
            textField.height.equalTo(50)

        }

        view.addSubview(joinButton)
        joinButton.snp.makeConstraints { button in
            button.centerY.equalTo(view.safeAreaLayoutGuide)
            button.leading.equalTo(usernameTextField.snp.trailing).offset(10)
            button.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }

    @objc func didTapJoinButton() {
        if let text = usernameTextField.text, text.isEmpty == false, text.count <= 10 {
            self.navigationController?.pushViewController(streamChatViewController, animated: true)
            StreamChat.shared.setupNetworkCommunication()
            StreamChat.shared.joinChat(username: text)
            usernameTextField.text = nil
        } else {
            print("10글자!")
        }
    }
}
