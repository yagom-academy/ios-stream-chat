//
//  String+Extension.swift
//  StreamChat
//
//  Created by Ryan-Son on 2021/08/11.
//

import Foundation

extension String {

    enum StreamAffix {

        enum Prefix {
            static let join = "USR_NAME::"
            static let send = "MSG::"
            static let leave = "LEAVE::"
        }

        enum Infix {
            static let receive = "::"
        }

        enum Suffix {
            static let endOfMessage = "::END"
        }
    }

    var asJoiningStreamData: Data? {
        var output: String = self
        output.insert(contentsOf: StreamAffix.Prefix.join, at: startIndex)
        output.append(contentsOf: StreamAffix.Suffix.endOfMessage)
        return output.data(using: .utf8)
    }

    var asSendingStreamData: Data? {
        var output: String = self
        output.insert(contentsOf: StreamAffix.Prefix.send, at: startIndex)
        output.append(contentsOf: StreamAffix.Suffix.endOfMessage)
        return output.data(using: .utf8)
    }

    static var leavingStreamData: Data? {
        return (String.StreamAffix.Prefix.leave + String.StreamAffix.Suffix.endOfMessage).data(using: .utf8)
    }
}
