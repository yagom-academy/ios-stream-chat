
import Foundation

enum CommunicationMessage: CustomStringConvertible {
    case join(String)
    
    var description: String {
        switch self {
        case .join(let nickname):
            return "USR_NAME::\(nickname)"
        }
    }
}
