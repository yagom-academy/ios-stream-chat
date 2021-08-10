//
//  MessageTableViewCell.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/10.
//

import UIKit

final class ChatTableViewCell: UITableViewCell {
    
    static let identifier = "MessageTableViewCell"
    private let chatBubbleImageView = UIImageView()
    private let chatLabel = UILabel()
    private var myChatImageViewConstraints: [NSLayoutConstraint] = []
    private var othersChatImageViewConstraints: [NSLayoutConstraint] = []
    private var myChatLabelConstraints: [NSLayoutConstraint] = []
    private var othersChatLabelConstraints: [NSLayoutConstraint] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(chatInformation: Chat) {
        setUI(isMyMessage: chatInformation.isMyMessage)
        chatLabel.text = chatInformation.message
        chatBubbleImageView.image = chatInformation.isMyMessage ? UIImage(named: "bubble_right") : UIImage(named: "bubble_left")
    }
    
    private func setUI(isMyMessage: Bool) {
        self.contentView.backgroundColor = .darkGray
        setSpeechImageView(isMyMessage: isMyMessage)
        setMessageLabel(isMyMessage: isMyMessage)
    }
    
    private func setSpeechImageView(isMyMessage: Bool) {
        self.contentView.addSubview(chatBubbleImageView)
        chatBubbleImageView.translatesAutoresizingMaskIntoConstraints = false
        chatBubbleImageView.tintColor = isMyMessage ?  .yellow : .systemGray
        setConstraintOfSpeechImageView(isMyMessage: isMyMessage)
    }
    
    private func setMessageLabel(isMyMessage: Bool) {
        self.chatBubbleImageView.addSubview(chatLabel)
        chatLabel.numberOfLines = 0
        chatLabel.translatesAutoresizingMaskIntoConstraints = false
        chatLabel.textColor = isMyMessage ? .black : .white
        setConstraintOfChatLabel(isMyMessage: isMyMessage)
    }
    
    // MARK: Constraints
    
    private func setConstraintOfSpeechImageView(isMyMessage: Bool) {
        if isMyMessage {
            NSLayoutConstraint.deactivate(othersChatImageViewConstraints)
            setConstraintOfMyChatImageView()
            NSLayoutConstraint.activate(myChatImageViewConstraints)
            return
        }
        
        NSLayoutConstraint.deactivate(myChatImageViewConstraints)
        setConstraintOfOthersChatImageView()
        NSLayoutConstraint.activate(othersChatImageViewConstraints)
    }
    
    private func setConstraintOfChatLabel(isMyMessage: Bool) {
        if isMyMessage {
            NSLayoutConstraint.deactivate(othersChatLabelConstraints)
            setConstraintOfMyMessageLabel()
            NSLayoutConstraint.activate(myChatLabelConstraints)
            return
        }
        
        NSLayoutConstraint.deactivate(myChatLabelConstraints)
        setConstraintOfOthersMessageLabel()
        NSLayoutConstraint.activate(othersChatLabelConstraints)
    }
    
    private func setConstraintOfOthersChatImageView() {
        myChatImageViewConstraints = [ chatBubbleImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Inset.chatTableViewCellInset),
                                       chatBubbleImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -Inset.chatTableViewCellInset),
                                       chatBubbleImageView.widthAnchor.constraint(lessThanOrEqualTo: self.contentView.widthAnchor, constant: -50),
                                       chatBubbleImageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -Inset.chatTableViewCellInset) ]
    }
    
    private func setConstraintOfMyChatImageView() {
        othersChatImageViewConstraints = [ chatBubbleImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: Inset.chatTableViewCellInset),
                                           chatBubbleImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: Inset.chatTableViewCellInset),
                                           chatBubbleImageView.widthAnchor.constraint(lessThanOrEqualTo: self.contentView.widthAnchor, constant: -50),
                                           chatBubbleImageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, constant: -Inset.chatTableViewCellInset) ]
    }
    
    private func setConstraintOfMyMessageLabel() {
        myChatLabelConstraints = [ chatLabel.topAnchor.constraint(equalTo: self.chatBubbleImageView.topAnchor, constant: Inset.chatTableViewCellInset/2),
                                   chatLabel.leadingAnchor.constraint(equalTo: self.chatBubbleImageView.leadingAnchor, constant: Inset.chatTableViewCellInset),
                                   chatLabel.trailingAnchor.constraint(equalTo: self.chatBubbleImageView.trailingAnchor, constant: -Inset.chatTableViewCellInset),
                                   chatLabel.heightAnchor.constraint(equalTo: self.chatBubbleImageView.heightAnchor, constant: -Inset.chatTableViewCellInset) ]
    }
    
    private func setConstraintOfOthersMessageLabel() {
        othersChatLabelConstraints = [ chatLabel.topAnchor.constraint(equalTo: self.chatBubbleImageView.topAnchor, constant: Inset.chatTableViewCellInset/2),
                                       chatLabel.leadingAnchor.constraint(equalTo: self.chatBubbleImageView.leadingAnchor, constant: Inset.chatTableViewCellInset),
                                       chatLabel.trailingAnchor.constraint(equalTo: self.chatBubbleImageView.trailingAnchor, constant: -Inset.chatTableViewCellInset),
                                       chatLabel.heightAnchor.constraint(equalTo: self.chatBubbleImageView.heightAnchor, constant: -Inset.chatTableViewCellInset) ]
    }
}
