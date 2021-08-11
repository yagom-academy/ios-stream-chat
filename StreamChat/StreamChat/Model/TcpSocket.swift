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
        var buffer = [UInt8](repeating: 0, count: totalSizeOfBuffer)
        guard let bufferOfReaded = inputStream?.read(&buffer, maxLength: totalSizeOfBuffer) else {
            throw TcpError.failedToReadInputStream
        }

        let differenceOfBufferBytes = totalSizeOfBuffer - bufferOfReaded
        if differenceOfBufferBytes > 0 {
            let countToDrop = differenceOfBufferBytes
            let customizedBuffer = buffer.dropLast(countToDrop)
            
            return Data(customizedBuffer)
        } else {
            throw TcpError.noDataReceived
        }
    }
    func disconnect() {
        inputStream?.close()
        outputStream?.close()
    }
}
