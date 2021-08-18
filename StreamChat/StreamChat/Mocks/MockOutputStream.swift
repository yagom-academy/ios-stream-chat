//
//  MockOutputStream.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/18.
//

import Foundation

final class MockOutputStream: outputStreamProtocol {
    weak var delegate: StreamDelegate?
    
    func open() {
        
    }
    
    func close() {
        
    }
    
    func write(data: Data) -> Int {
        return 0
    }
    
    func schedule(in aRunLoop: RunLoop, forMode mode: RunLoop.Mode) {
        
    }
    
}
