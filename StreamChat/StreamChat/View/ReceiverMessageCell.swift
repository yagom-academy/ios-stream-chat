//
//  ReceiverMessageCell.swift
//  StreamChat
//
//  Created by 황인우 on 2021/08/17.
//

import UIKit

class ReceiverMessageCell: UITableViewCell {
    static let identifier = "ReceiverMessageCell"
    
    private let receiverSpeechBubble: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bubble_right")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = UIColor(red: 0, green: 0.3804, blue: 0.9176, alpha: 1.0)
        return imageView
    }()
    
    private let speechBubbleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpMessageCell()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUpMessageCell() {
        receiverSpeechBubble.addSubview(speechBubbleLabel)
        self.contentView.addSubview(receiverSpeechBubble)
        NSLayoutConstraint.activate([
            receiverSpeechBubble.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            receiverSpeechBubble.leadingAnchor.constraint(greaterThanOrEqualTo: self.contentView.trailingAnchor, constant: 50),
            receiverSpeechBubble.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            receiverSpeechBubble.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            
            speechBubbleLabel.topAnchor.constraint(equalTo: receiverSpeechBubble.topAnchor),
            speechBubbleLabel.leadingAnchor.constraint(equalTo: receiverSpeechBubble.leadingAnchor),
            speechBubbleLabel.trailingAnchor.constraint(equalTo: receiverSpeechBubble.trailingAnchor, constant: -8),
            speechBubbleLabel.bottomAnchor.constraint(equalTo: receiverSpeechBubble.bottomAnchor)
        ])
    }
    
    func changeLabelText(_ text: String) {
        speechBubbleLabel.text = text
    }
}
