//
//  AlertTableViewCell.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/13.
//

import Foundation
import UIKit

final class AlertTableViewCell: UITableViewCell {
    
    static let identifier = "AlertTableViewCell"
    private let chatContainerView = UIView()
    private let chatLabel = UILabel()
    private let dateLabel = UILabel()
    
    func configure(chatInformation: Chat) {
        setUI()
        chatLabel.text = chatInformation.message
        dateLabel.text = StreamData.convertDateToString(date: chatInformation.date)
    }
    
    // MARK: UI Setting
    
    private func setUI() {
        self.contentView.backgroundColor = .darkGray
        setbackgroundView()
        setMessageLabel()
        setDateLabel()
    }
    
    private func setbackgroundView() {
        self.contentView.addSubview(chatContainerView)
        chatContainerView.backgroundColor = .systemGray4
        chatContainerView.layer.cornerRadius = 10
        chatContainerView.translatesAutoresizingMaskIntoConstraints = false
        setConstraintOfchatContainerView()
    }
    
    private func setMessageLabel() {
        self.chatContainerView.addSubview(chatLabel)
        chatLabel.numberOfLines = 0
        chatLabel.textColor = .darkGray
        chatLabel.translatesAutoresizingMaskIntoConstraints = false
        setConstraintOfChatLabel()
    }
    
    private func setDateLabel() {
        self.contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textColor = .systemGray5
        setConstraintOfDateLabel()
    }
    
    // MARK: Constraints Setting
    
    private func setConstraintOfchatContainerView() {
        NSLayoutConstraint.activate([ chatContainerView.topAnchor.constraint(equalTo: self.contentView.topAnchor,
                                                                             constant: ChatTableViewCellConstants.chatTableViewCellInset),
                                      chatContainerView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
                                      chatContainerView.widthAnchor.constraint(equalToConstant: 200)])
    }
    
    private func setConstraintOfChatLabel() {
        NSLayoutConstraint.activate([ chatLabel.centerXAnchor.constraint(equalTo: self.chatContainerView.centerXAnchor),
                                      chatLabel.centerYAnchor.constraint(equalTo: self.chatContainerView.centerYAnchor),
                                      chatLabel.topAnchor.constraint(equalTo: self.chatContainerView.topAnchor,
                                                                     constant: 3),
                                      chatLabel.bottomAnchor.constraint(equalTo: self.chatContainerView.bottomAnchor,
                                                                        constant: -3) ])
    }
    
    private func setConstraintOfDateLabel() {
        NSLayoutConstraint.activate([ dateLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
                                      dateLabel.topAnchor.constraint(equalTo: self.chatContainerView.bottomAnchor,
                                                                     constant: 3),
                                      dateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,
                                                                        constant: -ChatTableViewCellConstants.chatTableViewCellInset) ])
    }
    
}
