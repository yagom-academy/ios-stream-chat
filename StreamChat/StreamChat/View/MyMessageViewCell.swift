//
//  ReceiverMessageCell.swift
//  StreamChat
//
//  Created by James on 2021/08/17.
//

import UIKit

class MyMessageViewCell: UITableViewCell {
    static let identifier = "MyMessageViewCell"
    
    private let mySpeechBubble: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bubble_right")?.withRenderingMode(.alwaysTemplate)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.tintColor = UIColor(red: 0, green: 0.6863, blue: 0.9176, alpha: 1.0)
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
        mySpeechBubble.addSubview(speechBubbleLabel)
        self.contentView.addSubview(mySpeechBubble)
        NSLayoutConstraint.activate([
            mySpeechBubble.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            mySpeechBubble.leadingAnchor.constraint(greaterThanOrEqualTo: self.contentView.leadingAnchor, constant: 50),
            mySpeechBubble.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            mySpeechBubble.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            
            speechBubbleLabel.topAnchor.constraint(equalTo: mySpeechBubble.topAnchor, constant: 8),
            speechBubbleLabel.leadingAnchor.constraint(equalTo: mySpeechBubble.leadingAnchor, constant: 8),
            speechBubbleLabel.trailingAnchor.constraint(equalTo: mySpeechBubble.trailingAnchor, constant: -8),
            speechBubbleLabel.bottomAnchor.constraint(equalTo: mySpeechBubble.bottomAnchor, constant: -8)
        ])
    }
    
    func changeLabelText(_ text: String) {
        speechBubbleLabel.text = text
    }
}
