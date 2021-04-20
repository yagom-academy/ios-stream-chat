
import XCTest
@testable import StreamChat

class StreamChatManagerTests: XCTestCase {
    let chatManager = ChatManager()
    
    override func setUpWithError() throws {
        super.setUp()
    }

    override func tearDownWithError() throws {
        super.tearDown()
    }

    func testConnectSocket() throws {
        XCTAssertNil(chatManager.inputStream)
        XCTAssertNil(chatManager.outputStream)
        
        chatManager.connectSocket()
        
        XCTAssertNotNil(chatManager.inputStream)
        XCTAssertNotNil(chatManager.outputStream)
    }
}
