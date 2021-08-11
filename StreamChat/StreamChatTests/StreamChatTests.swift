//
//  StreamChatTests.swift
//  StreamChatTests
//
//  Created by steven on 8/11/21.
//

import XCTest
@testable import StreamChat

class StreamChatTests: XCTestCase {

    func test_메시지_전송() {
        let sessionManager = StreamManager()
        
        sessionManager.setup()
        sessionManager.open()
        
        sessionManager.send(message: "USR_NAME::james::END")
        sessionManager.send(message: "LEAVE::::END")
        sessionManager.close()
    }

}
