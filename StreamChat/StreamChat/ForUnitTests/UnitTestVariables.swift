//
//  UnitTestConstants.swift
//  StreamChatTests
//
//  Created by 최정민 on 2021/08/18.
//

import Foundation

enum UnitTestVariables {
    private static var serverConnectionTestList: [String] = []
    static func appendFunctionNameIntoServerConnectionTestList(_ functionName: String) {
        UnitTestVariables.serverConnectionTestList.append(functionName)
    }
    static func resetServerConnectionTestList() {
        UnitTestVariables.serverConnectionTestList = []
    }
    static func getServerConnectionTestList() -> [String] {
        UnitTestVariables.serverConnectionTestList
    }
}
