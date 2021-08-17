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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoImageView.image = ViewImage.logo
        userNameTextField.delegate = self
        enterChatRoomButton.isEnabled = false
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
            enterChatRoomButton.backgroundColor = ViewColor.brown
            enterChatRoomButton.isEnabled = true
        }
        
        return true
    }
}
