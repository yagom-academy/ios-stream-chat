import Foundation

struct ChatConnectionMessage {
    func createJoinMessageFormat(username: String) -> Data {
        "USR_NAME::\(username)".data(using: .utf8)!
    }
}
