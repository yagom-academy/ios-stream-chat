//
//  Extension+String.swift
//  StreamChat
//
//  Created by Fezravien on 2021/08/10.
//

import Foundation

extension String {
    func withoutWhitespace() -> String {
        return self.replacingOccurrences(of: "\n", with: "")
            .replacingOccurrences(of: "\r", with: "")
    }
}
