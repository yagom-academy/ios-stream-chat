//
//  MessageTableViewCell.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/10.
//

import UIKit

final class MyChatTableViewCell: UITableViewCell {
    
    static let identifier = "MyChatTableViewCell"
    private let chatBubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .yellow
        return imageView
    }()
    
    private let chatLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray5
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        return label
    }()
    
    // MARK: Configuare function
  
    func configure(chatInformation: Chat) {
        setUI()
        chatLabel.text = chatInformation.message
        dateLabel.text = StreamData.convertDateToString(date: chatInformation.date)
        chatBubbleImageView.image = UIImage(named: "bubble_right")
    }
    
    // MARK: UI Setting
    
    private func setUI() {
        self.contentView.backgroundColor = .darkGray
        addAllSubviews()
        setConstraintOfChatBubbleImageView()
        setConstraintOfChatLabel()
        setConstraintOfDateLabel()
    }
    
    private func addAllSubviews() {
        self.contentView.addSubview(chatBubbleImageView)
        self.chatBubbleImageView.addSubview(chatLabel)
        self.contentView.addSubview(dateLabel)
    }
    
    // MARK: Constraints Setting
    
    private func setConstraintOfChatBubbleImageView() {
        NSLayoutConstraint.activate([chatBubbleImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor,
                                                                              constant: ChatTableViewCellConstants.chatTableViewCellInset),
                                     chatBubbleImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,
                                                                                   constant: -ChatTableViewCellConstants.chatTableViewCellInset),
                                     chatBubbleImageView.widthAnchor.constraint(lessThanOrEqualTo: self.contentView.widthAnchor,
                                                                                constant: -50) ])
    }
    
    private func setConstraintOfChatLabel() {
        NSLayoutConstraint.activate([ chatLabel.topAnchor.constraint(equalTo: self.chatBubbleImageView.topAnchor,
                                                                     constant: ChatTableViewCellConstants.chatTableViewCellInset / 2),
                                      chatLabel.leadingAnchor.constraint(equalTo: self.chatBubbleImageView.leadingAnchor,
                                                                         constant: ChatTableViewCellConstants.chatTableViewCellInset - 5),
                                      chatLabel.trailingAnchor.constraint(equalTo: self.chatBubbleImageView.trailingAnchor,
                                                                          constant: -ChatTableViewCellConstants.chatTableViewCellInset),
                                      chatLabel.heightAnchor.constraint(equalTo: self.chatBubbleImageView.heightAnchor,
                                                                        constant: -ChatTableViewCellConstants.chatTableViewCellInset) ])
    }
    
    private func setConstraintOfDateLabel() {
        NSLayoutConstraint.activate([ dateLabel.trailingAnchor.constraint(equalTo: self.chatBubbleImageView.trailingAnchor),
                                      dateLabel.topAnchor.constraint(equalTo: self.chatBubbleImageView.bottomAnchor,
                                                                     constant: 3),
                                      dateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,
                                                                        constant: -ChatTableViewCellConstants.chatTableViewCellInset) ])
    }
   
}
