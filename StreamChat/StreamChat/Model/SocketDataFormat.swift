
import Foundation

enum SocketDataFormat: CustomStringConvertible {
    case join(String)
    case send(String)
    case userJoined
    case userLeft
    
    var description: String {
        switch self {
        case .join(let nickname):
            return "USR_NAME::\(nickname)"
        case .send(let message):
            return "MSG::\(message)"
        case .userJoined:
            return "has joined\n"
        case .userLeft:
            return "has left\n"
        }
    }
}
