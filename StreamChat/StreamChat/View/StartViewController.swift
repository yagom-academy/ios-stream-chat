//
//  StartViewController.swift
//  StreamChat
//
//  Created by 강경 on 2021/08/17.
//

import UIKit

class StartViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var enterChatRoomButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoImageView.image = ViewImage.logo
    }
}
