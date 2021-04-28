import UIKit

final class ViewController: UIViewController {
    private let chatNetwork = ChatNetwork(username: "3percent")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chatNetwork.connectChat()
    }
}
