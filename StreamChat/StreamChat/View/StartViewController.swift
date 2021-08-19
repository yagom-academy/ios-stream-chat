//
//  StartViewController.swift
//  StreamChat
//
//  Created by 강경 on 2021/08/17.
//

import UIKit

final class StartViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var enterChatRoomButton: UIButton!
    
    private let viewModel = StartViewModel()

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStartView()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ChattingViewController.segueIdentifier {
            let chattingViewController = segue.destination as? ChattingViewController
            
            if let chatting = sender as? Chatting {
                chattingViewController?.viewModel.setChatting(chatting)
            }
        }
    }
    @IBAction func clickEnterChatRoomButton(_ sender: Any) {
        enterTheChatRoom()
        performSegue(withIdentifier: ChattingViewController.segueIdentifier,
                     sender: viewModel.getChatting())
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let text = (userNameTextField.text! as NSString).replacingCharacters(in: range,
                                                                             with: string)
        if text.isEmpty || text.count > ViewSize.maximumUserName {
            setEnterChatRoomButton(titleColor: ViewColor.lightGray,
                                   backgroundColor: ViewColor.nomalWhite, isEnable: false)
        } else {
            setEnterChatRoomButton(titleColor: ViewColor.nomalWhite,
                                   backgroundColor: ViewColor.nomalBrown, isEnable: true)
        }
        
        return true
    }
    private func setStartView() {
        logoImageView.image = ViewImage.logo
        userNameTextField.delegate = self
        enterChatRoomButton.isEnabled = false
    }
    private func enterTheChatRoom() {
        guard let userName: String = userNameTextField.text else {
            return
        }
        do {
            try viewModel.enterTheChatRoom(userName: userName)
        } catch {
            putUpInappropriateNameErrorAlert(error: error)
            userNameTextField.text = nil
        }
    }
    private func putUpInappropriateNameErrorAlert(error: Error) {
        let alert = UIAlertController(title: "", message: "\(error)",
                                      preferredStyle: UIAlertController.Style.alert)
        let actionOfOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(actionOfOk)
        present(alert, animated: false, completion: nil)
    }
    private func setEnterChatRoomButton(titleColor: UIColor?, backgroundColor: UIColor?,
                                        isEnable: Bool) {
        enterChatRoomButton.titleLabel?.textColor = titleColor
        enterChatRoomButton.backgroundColor = backgroundColor
        enterChatRoomButton.isEnabled = isEnable
    }
}
