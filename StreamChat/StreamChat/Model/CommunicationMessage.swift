
import Foundation

enum CommunicationMessage: CustomStringConvertible {
    case join(String)
    case send(String)
    
    var description: String {
        switch self {
        case .join(let nickname):
            return "USR_NAME::\(nickname)"
        case .send(let message):
            return "MSG::\(message)"
        }
    }
}
