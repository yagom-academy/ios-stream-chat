
import Foundation

struct ChatMessage: Message {
    var content: String
    var receivedTime: Date
    let sender: String
}
