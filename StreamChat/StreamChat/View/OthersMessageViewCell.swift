//
//  SenderMessageViewCell.swift
//  StreamChat
//
//  Created by James on 2021/08/17.
//

import UIKit

class OthersMessageViewCell: UITableViewCell {
    static let identifier = "OthersMessageViewCell"
    
    private let otherSpeechBubble: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bubble_left")?.withRenderingMode(.alwaysTemplate)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.tintColor = UIColor(red: 0, green: 0.9176, blue: 0, alpha: 1.0)
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
        self.contentView.backgroundColor = .white
        otherSpeechBubble.addSubview(speechBubbleLabel)
        self.contentView.addSubview(otherSpeechBubble)
        NSLayoutConstraint.activate([
            otherSpeechBubble.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            otherSpeechBubble.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            otherSpeechBubble.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            otherSpeechBubble.trailingAnchor.constraint(lessThanOrEqualTo: self.contentView.trailingAnchor, constant: -50),
            
            speechBubbleLabel.topAnchor.constraint(equalTo: otherSpeechBubble.topAnchor, constant: 8),
            speechBubbleLabel.leadingAnchor.constraint(equalTo: otherSpeechBubble.leadingAnchor, constant: 8),
            speechBubbleLabel.trailingAnchor.constraint(equalTo: otherSpeechBubble.trailingAnchor, constant: -8),
            speechBubbleLabel.bottomAnchor.constraint(equalTo: otherSpeechBubble.bottomAnchor, constant: -8)
        ])
    }
    
    func changeLabelText(_ text: String) {
        speechBubbleLabel.text = text
    }
}
