//
//  ChatRoom.swift
//  StreamChat
//
//  Created by Ryan-Son on 2021/08/10.
//

import Foundation

final class ChatRoom: NSObject {

    private enum ConnectionSetting {

        // MARK: TCP Connection information

        static let host = NetworkConnection.host
        static let port = NetworkConnection.port
        static let maxReadLength = 2400
    }

    static let system = User(name: "SYS", senderType: .system)

    private var inputStream: InputStream?
    private var outputStream: OutputStream?
    private var user: User?
    weak var delegate: ChatRoomDelegate?

    func connect() {
        Stream.getStreamsToHost(withName: ConnectionSetting.host,
                                port: ConnectionSetting.port,
                                inputStream: &inputStream,
                                outputStream: &outputStream)
        inputStream?.delegate = self
        scheduleStreamsToRunLoop()
        openStreams()
    }

    func join(with username: String) {
        user = User(name: username, senderType: .me)
        guard let joiningStreamData: Data = StreamDataFactory.makeStreamData(.join(username: username)) else {
            Log.logic.error("\(StreamChatError.failedToConvertStringToStreamData(location: #function))")
            return
        }
        write(joiningStreamData)
    }

    func send(message: String) {
        guard let sendingStreamData: Data = StreamDataFactory.makeStreamData(.send(message: message)) else {
            Log.logic.error("\(StreamChatError.failedToConvertStringToStreamData(location: #function))")
            return
        }
        write(sendingStreamData)
    }

    func leave() {
        guard let leavingStreamData: Data = StreamDataFactory.makeStreamData(.leave) else {
            Log.logic.error("\(StreamChatError.failedToConvertStringToStreamData(location: #function))")
            return
        }
        write(leavingStreamData)
    }

    func disconnect() {
        inputStream?.close()
        outputStream?.close()
    }

    // MARK: Private Methods

    private func scheduleStreamsToRunLoop() {
        inputStream?.schedule(in: .current, forMode: .common)
        outputStream?.schedule(in: .current, forMode: .common)
    }

    private func openStreams() {
        inputStream?.open()
        outputStream?.open()
    }

    private func write(_ streamData: Data) {
        streamData.withUnsafeBytes { rawBufferPointer in
            guard let pointer = rawBufferPointer.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                Log.network.error("\(StreamChatError.failedToWriteOnStream)")
                return
            }
            outputStream?.write(pointer, maxLength: streamData.count)
        }
    }
}

// MARK: - StreamDelegate

extension ChatRoom: StreamDelegate {

    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .openCompleted:
            Log.flowCheck.debug("연결 성공!")
        case .hasBytesAvailable:
            readAvailableBytes(from: aStream)
        case .endEncountered:
            leave()
            disconnect()
        case .errorOccurred:
            Log.network.notice("\(StreamChatError.errorOccurredAtStream)")
        case .hasSpaceAvailable:
            Log.network.info("더 사용할 수 있는 버퍼가 있어요. case: hasSpaceAvailable")
        default:
            Log.network.notice("\(StreamChatError.unknown(location: #function))")
        }
    }

    // MARK: Private Methods

    private func readAvailableBytes(from stream: Stream) {
        guard let stream = stream as? InputStream else { return }
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: ConnectionSetting.maxReadLength)

        while stream.hasBytesAvailable {
            guard let bytesRead = inputStream?.read(buffer, maxLength: ConnectionSetting.maxReadLength) else { return }

            if let error = stream.streamError, bytesRead < 0 {
                Log.network.error("\(StreamChatError.streamDataReadingFailed(error: error))")
                break
            }

            if let message = constructMessage(with: buffer, length: bytesRead) {
                delegate?.didReceiveMessage(message)
            }
        }
    }

    private func constructMessage(with buffer: UnsafeMutablePointer<UInt8>, length: Int) -> Message? {
        guard let strings = String(bytesNoCopy: buffer, length: length, encoding: .utf8, freeWhenDone: true)?
                .components(separatedBy: StreamDataFactory.Infix.receive),
              let name = strings.first,
              let message = strings.last else {
            Log.logic.error("\(StreamChatError.failedToConvertByteToString)")
            return nil
        }

        let isSystemMessage: Bool = strings.count <= 1

        if isSystemMessage {
            return Message(sender: ChatRoom.system, text: message, dateTime: Date())
        } else {
            guard let sender = (name == user?.name) ? user : User(name: name, senderType: .someoneElse) else {
                return nil
            }
            return Message(sender: sender, text: message, dateTime: Date())
        }
    }
}
