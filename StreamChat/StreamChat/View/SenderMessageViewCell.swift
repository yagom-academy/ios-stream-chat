//
//  SenderMessageViewCell.swift
//  StreamChat
//
//  Created by 황인우 on 2021/08/17.
//

import UIKit

class SenderMessageViewCell: UITableViewCell {
    static let identifier = "SenderMessageViewCell"
    
    private let senderSpeechBubble: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bubble_left")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = UIColor(red: 0, green: 0.8275, blue: 0.3294, alpha: 1.0)
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
        senderSpeechBubble.addSubview(speechBubbleLabel)
        self.contentView.addSubview(senderSpeechBubble)
        NSLayoutConstraint.activate([
            senderSpeechBubble.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            senderSpeechBubble.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            senderSpeechBubble.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            senderSpeechBubble.trailingAnchor.constraint(greaterThanOrEqualTo: self.contentView.trailingAnchor, constant: -50),
            
            speechBubbleLabel.topAnchor.constraint(equalTo: senderSpeechBubble.topAnchor),
            speechBubbleLabel.leadingAnchor.constraint(equalTo: senderSpeechBubble.leadingAnchor, constant: 8),
            speechBubbleLabel.trailingAnchor.constraint(equalTo: senderSpeechBubble.trailingAnchor),
            speechBubbleLabel.bottomAnchor.constraint(equalTo: senderSpeechBubble.bottomAnchor)
        ])
    }
    
    func changeLabelText(_ text: String) {
        speechBubbleLabel.text = text
    }
}
