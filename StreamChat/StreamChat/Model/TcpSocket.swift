//
//  TcpSocket.swift
//  StreamChat
//
//  Created by 강경 on 2021/08/09.
//

import Foundation

final class TcpSocket: NSObject {
    
    var inputStream: InputStream?
    var outputStream: OutputStream?
    
    func connect(host: String, port: Int) {
        // TODO: - deprecated 함수에대한 변경
        Stream.getStreamsToHost(withName: host, port: port, inputStream: &inputStream,
                                outputStream: &outputStream)
        inputStream?.open()
        outputStream?.open()
    }
    func send(data: String) {
        outputStream?.write(data, maxLength: data.count)
    }
    func receive(totalSizeOfBuffer: Int) throws -> Data {
        var initializedBuffer = [UInt8](repeating: 0, count: totalSizeOfBuffer)
        guard let bufferOfReaded = inputStream?.read(&initializedBuffer,
                                                     maxLength: totalSizeOfBuffer) else {
            throw TcpError.failedToReadInputStream
        }

        return try customizedBufferData(buffer: initializedBuffer,
                                        differenceOfBufferBytes: totalSizeOfBuffer - bufferOfReaded)
    }
    func disconnect() {
        inputStream?.close()
        outputStream?.close()
    }
    private func customizedBufferData(buffer: [UInt8],
                                      differenceOfBufferBytes: Int) throws -> Data {
        if differenceOfBufferBytes > 0 {
            let countToDrop = differenceOfBufferBytes
            let customizedBuffer = buffer.dropLast(countToDrop)
            
            return Data(customizedBuffer)
        } else {
            throw TcpError.noDataReceived
        }
    }
}
