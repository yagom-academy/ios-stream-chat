//
//  MessageTableViewCell.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/10.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    static let identifier = "MessageTableViewCell"
    
    private let speechBubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(chatInformation: Chat) {
        messageLabel.text = chatInformation.message
        speechBubbleImageView.image = chatInformation.isMyMessage ? UIImage(named: "bubble_left") : UIImage(named: "bubble_right")
    }
}
