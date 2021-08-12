//
//  OSLog+Extension.swift
//  StreamChat
//
//  Created by Ryan-Son on 2021/08/12.
//

import OSLog

extension OSLog {

    static let subsystem = Bundle.main.bundleIdentifier!
    static let networkLogger = Logger(subsystem: subsystem, category: "Network")
}
