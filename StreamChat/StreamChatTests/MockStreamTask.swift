//
//  MockStreamTask.swift
//  StreamChatTests
//
//  Created by James on 2021/08/13.
//
@testable import StreamChat
import Foundation

final class MockStreamTask: URLSessionStreamTask {
    var dataList = [Data]()
    var timeLimit: TimeInterval = 10
    var writeCounter: Int = 0
    var readDataCounter: Int = 0
    var closeWriteCounter: Int = 0
    var closeReadCounter: Int = 0
    var resumeDidCalled: Bool = false
    var resultHandler: (() -> Void)?
    var successfulDataString = "AvailableData"
    override func resume() {
        resumeDidCalled = true
    }
    
    override func readData(ofMinLength minBytes: Int, maxLength maxBytes: Int, timeout: TimeInterval, completionHandler: @escaping (Data?, Bool, Error?) -> Void) {
        let completeData = successfulDataString.data(using: .utf8)!
        readDataCounter += 1
        resultHandler?()
        return completionHandler(completeData, true, nil)
    }
    
    override func write(_ data: Data, timeout: TimeInterval, completionHandler: @escaping (Error?) -> Void) {
        dataList.append(data)
        writeCounter += 1
        resultHandler?()
    }
    
    override func closeWrite() {
        closeWriteCounter += 1
    }
    
    override func closeRead() {
        closeReadCounter += 1
    }
}
