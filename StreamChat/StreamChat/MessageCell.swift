//
//  TableViewCell.swift
//  StreamChat
//
//  Created by 기원우 on 2021/08/17.
//

import UIKit

final class MessageCell: UITableViewCell {
    static let reuseIfentifier = "messageCell"

    let receiveMessageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bubble_left")
        imageView.contentMode = .scaleToFill

        return imageView
    }()

    let receiveMessageLable: UILabel = {
        let label = UILabel()
        label.text = "placeholder receive Message"
        label.numberOfLines = 0
        return label
    }()

    let sendMessageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bubble_right")
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    let sendMessageLable: UILabel = {
        let label = UILabel()
        label.text = "placeholder send Message"
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func receiveMode(message: String) {
        contentView.addSubview(receiveMessageView)
        contentView.addSubview(receiveMessageLable)

        receiveMessageLable.text = message
        receiveMessageView.snp.makeConstraints { imageView in
            imageView.top.bottom.equalToSuperview().inset(5)
            imageView.leading.equalTo(self).inset(5)
            imageView.trailing.lessThanOrEqualTo(self).inset(100)
        }

        receiveMessageLable.snp.makeConstraints { label in
            label.top.bottom.equalTo(receiveMessageView).inset(5)
            label.leading.trailing.equalTo(receiveMessageView).inset(10)
        }
    }

    func sendMode(message: String) {
        contentView.addSubview(sendMessageView)
        contentView.addSubview(sendMessageLable)

        sendMessageLable.text = message
        sendMessageView.snp.makeConstraints { imageView in
            imageView.top.bottom.equalToSuperview().inset(5)
            imageView.trailing.equalTo(self).inset(5)
            imageView.leading.greaterThanOrEqualTo(self).inset(100)
        }

        sendMessageLable.snp.makeConstraints { label in
            label.top.bottom.equalTo(sendMessageView).inset(5)
            label.leading.trailing.equalTo(sendMessageView).inset(10)
        }
    }
}
