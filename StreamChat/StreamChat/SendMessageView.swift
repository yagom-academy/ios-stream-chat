//
//  SendMessageView.swift
//  StreamChat
//
//  Created by 기원우 on 2021/08/17.
//

import UIKit

final class SendMessageView: UIView {
    var delegate: StreamChatDelegate?

    private let messageTextfield: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.leftView = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: 10,
                                                  height: textField.frame.height))
        textField.leftViewMode = .always
        return textField
    }()

    let sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemBackground
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapSendButton), for: .touchUpInside)
        return button
    }()

    init() {
        super.init(frame: .zero)

        self.backgroundColor = .systemBackground
        setupSendButton()
        setupTextField()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
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

    private func setupTextField() {
        self.addSubview(messageTextfield)

        messageTextfield.snp.makeConstraints { textfield in
            textfield.top.leading.bottom.equalTo(self.safeAreaLayoutGuide).inset(10)
            textfield.trailing.equalTo(sendButton.snp.leading)
        }
    }

    @objc func didTapSendButton() {
        guard let text = messageTextfield.text,
              text.isEmpty == false else { return }
        delegate?.sendMessage(message: text)
        messageTextfield.text = nil
    }
}
