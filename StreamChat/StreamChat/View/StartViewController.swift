//
//  StartViewController.swift
//  StreamChat
//
//  Created by 강경 on 2021/08/17.
//

import UIKit

class StartViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var enterChatRoomButton: UIButton!
    private let startViewModel = StartViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoImageView.image = ViewImage.logo
        userNameTextField.delegate = self
        enterChatRoomButton.isEnabled = false
    }
    @IBAction func clickEnterChatRoomButton(_ sender: Any) {
        guard let userName: String = userNameTextField.text else {
            return
        }
        do {
            try startViewModel.enterTheChatRoom(userName: userName)
        } catch {
            putUpInappropriateNameErrorAlert(error: error)
            userNameTextField.text = ""
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        let text = (userNameTextField.text! as NSString).replacingCharacters(in: range,
                                                                             with: string)
        if text.isEmpty || text.count > ViewSize.maximumUserName {
            enterChatRoomButton.titleLabel?.textColor = ViewColor.lightGray
            enterChatRoomButton.backgroundColor = ViewColor.white
            enterChatRoomButton.isEnabled = false
        } else {
            enterChatRoomButton.titleLabel?.textColor = ViewColor.white
            enterChatRoomButton.backgroundColor = ViewColor.nomalBrown
            enterChatRoomButton.isEnabled = true
        }
        
        return true
    }
    private func putUpInappropriateNameErrorAlert(error: Error) {
        let alert = UIAlertController(title: "", message: "\(error)",
                                      preferredStyle: UIAlertController.Style.alert)
        let actionOfOk = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(actionOfOk)
        present(alert, animated: false, completion: nil)
    }
}
