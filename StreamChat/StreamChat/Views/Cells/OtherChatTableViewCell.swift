//
//  OtherChatTableViewCell.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/13.
//

import UIKit

class OtherChatTableViewCell: UITableViewCell {
    static let identifier = "OtherChatTableViewCell"
    private let chatBubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemGray
        return imageView
    }()
    
    private let chatLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray5
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        return label
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray5
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        return label
    }()
    
    // MARK: Configuare function
    
    func configure(chatInformation: Chat) {
        setUI(senderType: chatInformation.senderType)
        chatLabel.text = chatInformation.message
        dateLabel.text = StreamData.convertDateToString(date: chatInformation.date)
        chatBubbleImageView.image = UIImage(named: "bubble_left")
        userNameLabel.text = chatInformation.senderName
    }
    
    // MARK: UI Setting
    
    private func setUI(senderType: SenderIdentifier) {
        self.contentView.backgroundColor = .darkGray
        addAllSubviews()
        setConstraintOfUserNameLabel()
        setConstraintOfChatBubbleImageView()
        setConstraintOfChatLabel()
        setConstraintOfDateLabel()
    }
    
    private func addAllSubviews() {
        self.contentView.addSubview(userNameLabel)
        self.contentView.addSubview(chatBubbleImageView)
        self.chatBubbleImageView.addSubview(chatLabel)
        self.contentView.addSubview(dateLabel)
    }
    
    // MARK: Constraints Setting
    
    private func setConstraintOfUserNameLabel() {
        NSLayoutConstraint.activate([ userNameLabel.leadingAnchor.constraint(equalTo: chatBubbleImageView.leadingAnchor),
                                      userNameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor,
                                                                     constant: ChatTableViewCellConstants.chatTableViewCellInset)])
    }
    
    private func setConstraintOfChatBubbleImageView() {
        NSLayoutConstraint.activate([chatBubbleImageView.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor,
                                                                              constant: 3),
                                     chatBubbleImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,
                                                                                  constant: ChatTableViewCellConstants.chatTableViewCellInset),
                                     chatBubbleImageView.widthAnchor.constraint(lessThanOrEqualTo: self.contentView.widthAnchor,
                                                                                constant: -50) ])
    }
    
    private func setConstraintOfChatLabel() {
        NSLayoutConstraint.activate([ chatLabel.topAnchor.constraint(equalTo: chatBubbleImageView.topAnchor,
                                                                     constant: ChatTableViewCellConstants.chatTableViewCellInset / 2),
                                      chatLabel.leadingAnchor.constraint(equalTo: chatBubbleImageView.leadingAnchor,
                                                                         constant: ChatTableViewCellConstants.chatTableViewCellInset),
                                      chatLabel.trailingAnchor.constraint(equalTo: chatBubbleImageView.trailingAnchor,
                                                                          constant: -ChatTableViewCellConstants.chatTableViewCellInset + 5),
                                      chatLabel.heightAnchor.constraint(equalTo: chatBubbleImageView.heightAnchor,
                                                                        constant: -ChatTableViewCellConstants.chatTableViewCellInset) ])
    }
    
    private func setConstraintOfDateLabel() {
        NSLayoutConstraint.activate([ dateLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,
                                                                         constant: ChatTableViewCellConstants.chatTableViewCellInset),
                                      dateLabel.topAnchor.constraint(equalTo: chatBubbleImageView.bottomAnchor,
                                                                     constant: 3),
                                      dateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,
                                                                        constant: -ChatTableViewCellConstants.chatTableViewCellInset) ])
    }
  
}
