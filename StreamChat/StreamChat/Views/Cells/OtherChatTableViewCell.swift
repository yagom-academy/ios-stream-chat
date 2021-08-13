//
//  OtherChatTableViewCell.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/13.
//

import UIKit

class OtherChatTableViewCell: UITableViewCell {

    static let identifier = "OtherChatTableViewCell"
    private let chatBubbleImageView = UIImageView()
    private let chatLabel = UILabel()
    private let dateLabel = UILabel()
    private let userNameLabel = UILabel()
    
    func configure(chatInformation: Chat) {
        setUI(senderType: chatInformation.senderType)
        chatLabel.text = chatInformation.message
        dateLabel.text = StreamData.convertDateToString(date: chatInformation.date)
        chatBubbleImageView.image = UIImage(named: "bubble_left")
        userNameLabel.text = chatInformation.senderName
    }
    
    // MARK: UI Setting
    
    private func setUI(senderType: Identifier) {
        self.contentView.backgroundColor = .darkGray
        addAllSubviews()
        setUserNameLabel()
        setSpeechImageView()
        setMessageLabel()
        setDateLabel()
    }
    
    private func addAllSubviews() {
        self.contentView.addSubview(userNameLabel)
        self.contentView.addSubview(chatBubbleImageView)
        self.chatBubbleImageView.addSubview(chatLabel)
        self.contentView.addSubview(dateLabel)
    }
    
    private func setUserNameLabel() {
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.textColor = .systemGray5
        userNameLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        setConstraintOfUserNameLabel()
    }
    
    private func setSpeechImageView() {
        chatBubbleImageView.translatesAutoresizingMaskIntoConstraints = false
        chatBubbleImageView.tintColor = .systemGray
        setConstraintOfChatBubbleImageView()
    }
    
    private func setMessageLabel() {
        chatLabel.numberOfLines = 0
        chatLabel.translatesAutoresizingMaskIntoConstraints = false
        chatLabel.textColor = .white
        setConstraintOfChatLabel()
    }
    
    private func setDateLabel() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textColor = .systemGray5
        dateLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        setConstraintOfDateLabel()
    }
    
    // MARK: Constraints Setting
    
    private func setConstraintOfUserNameLabel() {
        NSLayoutConstraint.activate([ userNameLabel.leadingAnchor.constraint(equalTo: self.chatBubbleImageView.leadingAnchor),
                                      userNameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor,
                                                                     constant: ChatTableViewCellConstants.chatTableViewCellInset)])
    }
    
    private func setConstraintOfChatBubbleImageView() {
        
        NSLayoutConstraint.activate([chatBubbleImageView.topAnchor.constraint(equalTo: self.userNameLabel.bottomAnchor,
                                                                              constant: 3),
                                     chatBubbleImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,
                                                                                  constant: ChatTableViewCellConstants.chatTableViewCellInset),
                                     chatBubbleImageView.widthAnchor.constraint(lessThanOrEqualTo: self.contentView.widthAnchor,
                                                                                constant: -50) ])
    }
    
    private func setConstraintOfChatLabel() {
        
        NSLayoutConstraint.activate([ chatLabel.topAnchor.constraint(equalTo: self.chatBubbleImageView.topAnchor,
                                                                     constant: ChatTableViewCellConstants.chatTableViewCellInset / 2),
                                      chatLabel.leadingAnchor.constraint(equalTo: self.chatBubbleImageView.leadingAnchor,
                                                                         constant: ChatTableViewCellConstants.chatTableViewCellInset),
                                      chatLabel.trailingAnchor.constraint(equalTo: self.chatBubbleImageView.trailingAnchor,
                                                                          constant: -ChatTableViewCellConstants.chatTableViewCellInset + 5),
                                      chatLabel.heightAnchor.constraint(equalTo: self.chatBubbleImageView.heightAnchor,
                                                                        constant: -ChatTableViewCellConstants.chatTableViewCellInset) ])
    }
    
    private func setConstraintOfDateLabel() {
        
        NSLayoutConstraint.activate([ dateLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,
                                                                         constant: ChatTableViewCellConstants.chatTableViewCellInset),
                                      dateLabel.topAnchor.constraint(equalTo: self.chatBubbleImageView.bottomAnchor,
                                                                     constant: 3),
                                      dateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,
                                                                        constant: -ChatTableViewCellConstants.chatTableViewCellInset) ])
    }
  
}
