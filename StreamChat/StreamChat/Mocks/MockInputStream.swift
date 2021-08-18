//
//  MockInputStream.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/18.
//

import Foundation

final class MockInputStream: InputStreamProtocol {
    weak var delegate: StreamDelegate?
    
    func open() {
        UnitTestVariables.appendFunctionNameIntoServerConnectionTestList(UnitTestConstants.inputStreamOpen)
    }
    
    func close() {
        
    }
    
    func read(data: inout Data) -> Int {
        return 0
    }
    
    func schedule(in aRunLoop: RunLoop, forMode mode: RunLoop.Mode) {
        UnitTestVariables.appendFunctionNameIntoServerConnectionTestList(UnitTestConstants.inputStreamScheduleCall)
    }
    
}
