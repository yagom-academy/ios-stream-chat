//
//  MockURLSessionStreamTask.swift
//  StreamChatTests
//
//  Created by 최정민 on 2021/08/18.
//

import Foundation

final class MockURLSessionStreamTask: URLSessionStreamTaskProtocol {
    static var setUrlSessionStreamDelegate: (InputStreamProtocol, OutputStreamProtocol) -> Void = { _, _ in }
    static var inputStream: InputStreamProtocol?
    static var outputStream: OutputStreamProtocol?
    
    func resume() {
        UnitTestVariables.serverConnectionTestList.append(UnitTestConstants.resumeCall)
    }
    
    func captureStreams() {
        UnitTestVariables.serverConnectionTestList.append(UnitTestConstants.captureStreamsCall)
        MockURLSessionStreamTask.setUrlSessionStreamDelegate(MockURLSessionStreamTask.inputStream!, MockURLSessionStreamTask.outputStream!)
    }
    
    func closeRead() {
        
    }
    
    func closeWrite() {
        
    }
}
