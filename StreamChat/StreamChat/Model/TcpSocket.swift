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

        inputStream?.delegate = self
        inputStream?.schedule(in: .main, forMode: RunLoop.Mode.default)
        inputStream?.open()
        
        outputStream?.delegate = self
        outputStream?.schedule(in: .main, forMode: RunLoop.Mode.default)
        outputStream?.open()
    }
    func send(data: String) {
        // FIX: - 한글은 보내지지않는 오류 -> 유니코드 설정문제로 의심됨
        outputStream?.write(data, maxLength: data.count)
    }
    private func receive(complete: @escaping ((MessageData) -> Void)) throws {
        let customizedBuffer = try bufferData(totalSizeOfBuffer: StreamConstant.totalSizeOfBuffer)
        guard let receivedString = String(bytes: customizedBuffer,
                                          encoding: String.Encoding.utf8) else {
            throw ChattingError.failToConvertCustomizedBufferToString
        }
        let data = MessageDataManager().convertStringToMessageData(receivedString: receivedString)
        complete(data)
    }
    private func bufferData(totalSizeOfBuffer: Int) throws -> Data {
        var initializedBuffer = [UInt8](repeating: 0, count: totalSizeOfBuffer)
        guard let bufferOfRead = inputStream?.read(&initializedBuffer,
                                                     maxLength: totalSizeOfBuffer) else {
            throw TcpError.failedToReadInputStream
        }

        return try customizedBufferData(buffer: initializedBuffer,
                                        differenceOfBufferBytes: totalSizeOfBuffer - bufferOfRead)
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

extension TcpSocket: StreamDelegate {
    func stream(_ stream: Stream, handle eventCode: Stream.Event) {
        if stream === inputStream {
            switch eventCode {
            case Stream.Event.errorOccurred:
                InputStreamConstant.errorOccurred.printString()
            case Stream.Event.openCompleted:
                InputStreamConstant.openCompleted.printString()
            case Stream.Event.hasBytesAvailable:
                InputStreamConstant.hasBytesAvailable.printString()
                do {
                    try receive { data in
                        NotificationCenter.default.post(
                            name: Notification.Name(StreamConstant.receiveStreamData),
                            object: data)
                    }
                } catch {
                    print(error)
                }
            default:
                break
            }
        }
    }
}
