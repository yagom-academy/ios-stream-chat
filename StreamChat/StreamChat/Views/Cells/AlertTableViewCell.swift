//
//  AlertTableViewCell.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/13.
//

import UIKit

final class AlertTableViewCell: UITableViewCell {
    static let identifier = "AlertTableViewCell"
    private let chatContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let chatLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
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
    }
    
    // MARK: UI Setting
    
    private func setUI() {
        self.contentView.backgroundColor = .darkGray
        addAllSubViews()
        setConstraintOfchatContainerView()
        setConstraintOfChatLabel()
        setConstraintOfDateLabel()
    }
    
    private func addAllSubViews() {
        self.contentView.addSubview(chatContainerView)
        chatContainerView.addSubview(chatLabel)
        self.contentView.addSubview(dateLabel)
    }
    
    // MARK: Constraints Setting
    
    private func setConstraintOfchatContainerView() {
        NSLayoutConstraint.activate([chatContainerView.topAnchor.constraint(equalTo: self.contentView.topAnchor,
                                                                            constant: ChatTableViewCellConstants.chatTableViewCellInset),
                                     chatContainerView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
                                     chatContainerView.widthAnchor.constraint(equalToConstant: 200)])
    }
    
    private func setConstraintOfChatLabel() {
        NSLayoutConstraint.activate([chatLabel.centerXAnchor.constraint(equalTo: self.chatContainerView.centerXAnchor),
                                     chatLabel.centerYAnchor.constraint(equalTo: chatContainerView.centerYAnchor),
                                     chatLabel.topAnchor.constraint(equalTo: chatContainerView.topAnchor,
                                                                    constant: 3),
                                     chatLabel.bottomAnchor.constraint(equalTo: chatContainerView.bottomAnchor,
                                                                       constant: -3)])
    }
    
    private func setConstraintOfDateLabel() {
        NSLayoutConstraint.activate([dateLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
                                     dateLabel.topAnchor.constraint(equalTo: chatContainerView.bottomAnchor,
                                                                    constant: 3),
                                     dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                                       constant: -ChatTableViewCellConstants.chatTableViewCellInset)])
    }
    
}
