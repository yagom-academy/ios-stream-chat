//
//  InputStreamProtocol.swift
//  StreamChat
//
//  Created by 최정민 on 2021/08/18.
//

import Foundation

protocol InputStreamProtocol {
    var delegate: StreamDelegate? { get set }
    
    func open()
    
    func close()
    
    @discardableResult
    func read(data: inout Data) -> Int
    
    func schedule(in aRunLoop: RunLoop, forMode mode: RunLoop.Mode)
    
}

extension InputStream: InputStreamProtocol {
}
