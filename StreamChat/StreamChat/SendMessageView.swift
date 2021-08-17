//
//  SendMessageView.swift
//  StreamChat
//
//  Created by 기원우 on 2021/08/17.
//

import UIKit

final class SendMessageView: UIView {
    private let messageTextfield: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemPink
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftView = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: 10,
                                                  height: textField.frame.height))
        textField.leftViewMode = .always
        return textField
    }()

    private let sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.backgroundColor = .systemGreen
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    init() {
        super.init(frame: .zero)

        self.backgroundColor = .systemGray
        setupTextField()
        setupSendButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupTextField() {
        self.addSubview(messageTextfield)

        messageTextfield.snp.makeConstraints { textfield in
            textfield.top.leading.bottom.equalTo(self.safeAreaLayoutGuide).inset(10)
            textfield.width.equalTo(300)
        }
    }

    private func setupSendButton() {
        self.addSubview(sendButton)

        sendButton.snp.makeConstraints { button in
            button.width.equalTo(50)
            button.height.equalTo(25)
            button.trailing.equalTo(self.safeAreaLayoutGuide).inset(15)
            button.centerY.equalTo(self)
        }
    }

}
