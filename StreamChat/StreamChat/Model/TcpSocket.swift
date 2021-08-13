//
//  TcpSocket.swift
//  StreamChat
//
//  Created by 이영우 on 2021/08/09.
//

import Foundation

protocol TcpSocketDelegate: AnyObject {
    func receive(_ chatDataFormat: ChatReceiveFormat)
    func handleError(_ error: Error)
}

final class TcpSocket: NSObject {
    private var inputStream: InputStream?
    private var outputStream: OutputStream?
    private let host: String
    private let port: UInt32
    private let maxLength: Int
    private lazy var socketResponseHandler = SocketResponseHandler(maxBufferSize: maxLength)

    weak var delegate: TcpSocketDelegate?

    init(host: String, port: UInt32, maxLength: Int = 300) {
        self.host = host
        self.port = port
        self.maxLength = maxLength
        super.init()
        connect()
    }

    private func connect() {
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?

        CFStreamCreatePairWithSocketToHost(kCFAllocatorSystemDefault, host as CFString, port, &readStream, &writeStream)
        if let readStream = readStream, let writeStream = writeStream {
            inputStream = readStream.takeRetainedValue()
            outputStream = writeStream.takeRetainedValue()
        }
        if let inputStream = inputStream, let outputStream = outputStream {
            inputStream.delegate = self
            inputStream.schedule(in: .main, forMode: .default)
            outputStream.schedule(in: .main, forMode: .default)
            inputStream.open()
            outputStream.open()
        }
    }

    private func writeOnOutputStream(_ data: Data) {
        data.withUnsafeBytes {
            guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                return
            }
            if let outputStream = outputStream {
                outputStream.write(pointer, maxLength: data.count)
            }
        }
    }

    func join(userName: String) {
        guard let data = ChatPostFormat.myJoin(userName: userName).data else {
            return
        }
        writeOnOutputStream(data)
    }

    func send(message: String) {
        guard let data = ChatPostFormat.post(message: message).data else {
            return
        }
        writeOnOutputStream(data)
    }

    func disconnect() {
        guard let data = ChatPostFormat.myDisconnect.data else {
            return
        }
        writeOnOutputStream(data)
        guard let inputStream = inputStream, let outputStream = outputStream else {
            delegate?.handleError(ChatError.notExistedSocket)
            return
        }
        inputStream.close()
        outputStream.close()
    }
}

extension TcpSocket: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .hasBytesAvailable:
            guard let inputStream = aStream as? InputStream else {
                delegate?.handleError(ChatError.notExistedSocket)
                return
            }
            guard let message = socketResponseHandler.receivedMessage(inputStream: inputStream) else {
                delegate?.handleError(ChatError.invalidResponseFormat)
                return
            }
            self.delegate?.receive(message)
        case .endEncountered:
            disconnect()
        case .errorOccurred:
            print("error occurred")
        case .hasSpaceAvailable:
            print("has space available")
        default:
            print("some other event...")
        }
    }
}
