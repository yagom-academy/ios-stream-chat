//
//  otherMessageCell.swift
//  StreamChat
//
//  Created by 기원우 on 2021/08/17.
//

import UIKit
import SnapKit

final class OtherMessageCell: UITableViewCell {
    static let reuseIdentifier = "otherMessageCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "receive Username"
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        return label
    }()

    let messageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bubble_left")
        imageView.contentMode = .scaleToFill

        return imageView
    }()

    let messageLable: UILabel = {
        let label = UILabel()
        label.text = "placeholder receive Message"
        label.numberOfLines = 0
        return label
    }()

    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "receive Time"
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        return label
    }()

    func setupMessage(message: String, time: Date, username: String) {
        contentView.addSubview(messageView)
        contentView.addSubview(messageLable)
        contentView.addSubview(timeLabel)
        contentView.addSubview(usernameLabel)

        messageLable.text = message
        timeLabel.text = DateToStringFormatter.sherd.dateToStringTime(at: time)
        usernameLabel.text = username

        usernameLabel.snp.makeConstraints { label in
            label.top.equalToSuperview().inset(5)
            label.leading.equalTo(messageLable.snp.leading)
        }

        messageView.snp.makeConstraints { imageView in
            imageView.top.equalTo(usernameLabel.snp.bottom).offset(3)
            imageView.leading.equalTo(self).inset(5)
            imageView.trailing.lessThanOrEqualTo(self).inset(100)
        }

        messageLable.snp.makeConstraints { label in
            label.top.bottom.equalTo(messageView).inset(5)
            label.leading.trailing.equalTo(messageView).inset(10)
        }

        timeLabel.snp.makeConstraints { label in
            label.top.equalTo(messageView.snp.bottom).offset(3)
            label.leading.equalTo(messageLable.snp.leading)
            label.bottom.equalToSuperview().inset(5)
        }
    }
}
