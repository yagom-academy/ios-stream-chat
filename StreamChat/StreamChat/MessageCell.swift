//
//  TableViewCell.swift
//  StreamChat
//
//  Created by 기원우 on 2021/08/17.
//

import UIKit

final class MessageCell: UITableViewCell {
    static let reuseIfentifier = "messageCell"
    private let dateFormatter = DateFormatter()

    let receiveUsernameLabel: UILabel = {
        let label = UILabel()
        label.text = "receive Username"
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        return label
    }()

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

    let receiveTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "receive Time"
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
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

    let sendTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "receive Time"
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setupReceiveMessage(message: String, time: Date, username: String) {
        contentView.addSubview(receiveMessageView)
        contentView.addSubview(receiveMessageLable)
        contentView.addSubview(receiveTimeLabel)
        contentView.addSubview(receiveUsernameLabel)

        receiveMessageLable.text = message
        receiveTimeLabel.text = dateToStringTime(at: time)
        receiveUsernameLabel.text = username

        receiveUsernameLabel.snp.makeConstraints { label in
            label.top.equalToSuperview().inset(5)
            label.leading.equalTo(receiveMessageLable.snp.leading)
        }

        receiveMessageView.snp.makeConstraints { imageView in
            imageView.top.equalTo(receiveUsernameLabel.snp.bottom).offset(3)
            imageView.leading.equalTo(self).inset(5)
            imageView.trailing.lessThanOrEqualTo(self).inset(100)
        }

        receiveMessageLable.snp.makeConstraints { label in
            label.top.bottom.equalTo(receiveMessageView).inset(5)
            label.leading.trailing.equalTo(receiveMessageView).inset(10)
        }

        receiveTimeLabel.snp.makeConstraints { label in
            label.top.equalTo(receiveMessageView.snp.bottom).offset(3)
            label.leading.equalTo(receiveMessageLable.snp.leading)
            label.bottom.equalToSuperview().inset(5)
        }
    }

    func setupSendMessage(message: String, time: Date) {
        contentView.addSubview(sendMessageView)
        contentView.addSubview(sendMessageLable)
        contentView.addSubview(sendTimeLabel)

        sendMessageLable.text = message
        sendTimeLabel.text = dateToStringTime(at: time)

        sendMessageView.snp.makeConstraints { imageView in
            imageView.top.equalToSuperview().inset(5)
            imageView.trailing.equalTo(self).inset(5)
            imageView.leading.greaterThanOrEqualTo(self).inset(100)
        }

        sendMessageLable.snp.makeConstraints { label in
            label.top.bottom.equalTo(sendMessageView).inset(5)
            label.leading.trailing.equalTo(sendMessageView).inset(10)
        }

        sendTimeLabel.snp.makeConstraints { label in
            label.top.equalTo(sendMessageView.snp.bottom).offset(3)
            label.trailing.equalTo(sendMessageLable.snp.trailing).offset(3)
            label.bottom.equalToSuperview().inset(5)
        }
    }

}

extension MessageCell {
    func dateToStringTime(at date: Date) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        return dateFormatter.string(from: date)
    }
}
