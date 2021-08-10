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
        static let maxWriteLength = 2400
    }

    private enum DefaultUser {

        static let system = User(name: "SYS")
        static let unknown = User(name: "Unknown")
    }

    private var inputStream: InputStream?
    private var outputStream: OutputStream?
    private let system: User = DefaultUser.system
    private var user: User = DefaultUser.unknown

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
        user = User(name: username)
        write(username.asJoiningStreamData)
    }

    func send(message: String) {
        write(message.asSendingStreamData)
    }

    func leave() {
        write(String.leavingStreamData)
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

    private func write(_ streamData: Data?) {
        streamData?.withUnsafeBytes { rawBufferPointer in
            guard let pointer = rawBufferPointer.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                print("Output Stream: write 작업에 실패하였어요.")
                return
            }
            outputStream?.write(pointer, maxLength: ConnectionSetting.maxReadLength)
        }
    }
}

// MARK: - StreamDelegate

extension ChatRoom: StreamDelegate {

    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .openCompleted:
            print("연결 성공!")
        case .hasBytesAvailable:
            print("새로운 메시지를 받았어요 1")
            readAvailableBytes(from: aStream)
        case .endEncountered:
            print("새로운 메시지를 받았어요 2")
            leave()
            disconnect()
        case .errorOccurred:
            print("에러가 발생했어요.")
        case .hasSpaceAvailable:
            print("더 쓸 수 있는 버퍼가 있어요.")
        default:
            print("무슨 일이 일어났죠?")
        }
    }

    // MARK: Private Methods

    private func readAvailableBytes(from stream: Stream) {
        guard let stream = stream as? InputStream else { return }
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: ConnectionSetting.maxReadLength)

        while stream.hasBytesAvailable {
            guard let bytesRead = inputStream?.read(buffer, maxLength: ConnectionSetting.maxReadLength) else { return }

            if let error = stream.streamError, bytesRead < 0 {
                print("Input stream을 읽어들이던 중에 문제가 발생했어요.", error)
                break
            }

            if let message = constructMessage(with: buffer, length: bytesRead) {
                print(message)
            }
        }
    }

    private func constructMessage(with buffer: UnsafeMutablePointer<UInt8>, length: Int) -> Message? {
        guard let strings = String(bytesNoCopy: buffer, length: length, encoding: .utf8, freeWhenDone: true)?
                .components(separatedBy: String.StreamAffix.Infix.receive),
              let name = strings.first,
              let message = strings.last else {
            return nil
        }

        let isSystemMessage: Bool = strings.count <= 1

        if isSystemMessage {
            return Message(sender: system, text: message)
        } else {
            let sender: User = (name == user.name) ? user : User(name: name)
            return Message(sender: sender, text: message)
        }
    }
}
