//
//  InputStreamConstant.swift
//  StreamChat
//
//  Created by 강경 on 2021/08/20.
//

import Foundation

enum InputStreamConstant: String {
    case errorOccurred = "inputStream:ErrorOccurred"
    case openCompleted = "inputStream:OpenCompleted"
    case hasBytesAvailable = "inputStream:HasBytesAvailable"
        
    func printString() {
        print(self.rawValue)
    }
}
