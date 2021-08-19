//
//  ChattingViewController.swift
//  StreamChat
//
//  Created by 강경 on 2021/08/17.
//

import UIKit

final class ChattingViewController: UIViewController {

    static let segueIdentifier = "StartChattingView"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    let viewModel = ChattingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        addNotificationObserver()
    }
    @IBAction func sendMessage() {
        guard let message = messageField.text, message.isEmpty == false else {
            return
        }
        viewModel.send(message: message)
        
        let indexPath = IndexPath(row: viewModel.numberOfChatList() - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.none)
        tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: true)
        
        messageField.text = nil
    }
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                               object: nil, queue: .main) { (notification) in
            guard let userInfo = notification.userInfo else {
                return
            }
            guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            else {
                return
            }
            self.bottomConstraint.constant = keyboardFrame.height -
                ChattingViewConstant.lengthOfKeyboard
            
            guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey]
                    as? TimeInterval else {
                return
            }
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            }
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                               object: nil, queue: .main) { (notification) in
            guard let userInfo = notification.userInfo,
                  let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as?
                    TimeInterval else {
                return
            }
            self.bottomConstraint.constant = ChattingViewConstant.lengthOfChatInputWindow
            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            }
        }
    }
}

extension ChattingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfChatList()
    }
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = viewModel.chatInfo(index: indexPath.row)
        let identifier = chat.isMyMessage ? BubbleCell.rightCellIdentifier :
            BubbleCell.leftCellIdentifier
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier,
                                                 for: indexPath) as? BubbleCell else {
            return UITableViewCell()
        }
        cell.message.text = chat.message
        cell.writtenDateLabel.textColor = ViewColor.chatTime
        cell.writtenDateLabel.text = chat.writtenDate
        
        return cell
    }
}
