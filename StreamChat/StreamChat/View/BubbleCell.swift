//
//  BubbleCell.swift
//  StreamChat
//
//  Created by 강경 on 2021/08/18.
//

import UIKit

final class BubbleCell: UITableViewCell {
    
    static let rightCellIdentifier = "RightCell"
    static let leftCellIdentifier = "LeftCell"
    static let centerCellIdentifier = "CenterCell"
    
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var writtenDateLabel: UILabel!
    
    func update(chat: ChatModel) {
        message.text = chat.message
        writtenDateLabel.textColor = ViewColor.chatTime
        writtenDateLabel.text = chat.writtenDate
    }
}
