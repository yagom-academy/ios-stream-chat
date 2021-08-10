//
//  ChatRoom.swift
//  StreamChat
//
//  Created by Ryan-Son on 2021/08/10.
//

import Foundation

final class ChatRoom {

    private enum ConnectionSetting {

        // MARK: TCP Connection information

        static let host = NetworkConnection.host
        static let port = NetworkConnection.port
        static let maxReadLength = 2400
        static let maxWriteLength = 2400
    }

    private var inputStream: InputStream?
    private var outputStream: OutputStream?
    private var userName: String?

    func connect() {
        Stream.getStreamsToHost(withName: ConnectionSetting.host,
                                port: ConnectionSetting.port,
                                inputStream: &inputStream,
                                outputStream: &outputStream)
        scheduleStreamsToRunLoop()
        openStreams()
    }

    private func scheduleStreamsToRunLoop() {
        inputStream?.schedule(in: .current, forMode: .common)
        outputStream?.schedule(in: .current, forMode: .common)
    }

    private func openStreams() {
        inputStream?.open()
        outputStream?.open()
    }

    func join(with username: String) {
        self.userName = username

        let willJoinStreamData: Data? = username.asWillJoinStreamData
        willJoinStreamData?.withUnsafeBytes { rawBufferPointer in
            guard let pointer = rawBufferPointer.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                print("채팅에 참가하지 못했어요.")
                return
            }
            outputStream?.write(pointer, maxLength: ConnectionSetting.maxReadLength)
        }
    }

    func send(message: String) {
        let sendMessageStreamData = message.asSendingMessageStreamData
        sendMessageStreamData?.withUnsafeBytes { rawBufferPointer in
            guard let pointer = rawBufferPointer.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                print("메세지를 보내지 못했어요.")
                return
            }
            outputStream?.write(pointer, maxLength: ConnectionSetting.maxWriteLength)
        }
    }

    func disconnect() {
        inputStream?.close()
        outputStream?.close()
    }
}

fileprivate extension String {

    private enum StreamMessageAffix {

        enum Prefix {
            static let willJoin = "USR_NAME::"
            static let sendingMessage = "MSG::"
        }

        enum Suffix {
            static let endOfMessage = "::END"
            static let joined = " has joined"
            static let left = " has left"
            static let leave = "LEAVE::"
        }
    }

    var asWillJoinStreamData: Data? {
        var output: String = self
        output.insert(contentsOf: StreamMessageAffix.Prefix.willJoin, at: startIndex)
        output.insert(contentsOf: StreamMessageAffix.Suffix.endOfMessage, at: endIndex)
        return output.data(using: .utf8)
    }

    var asSendingMessageStreamData: Data? {
        var output: String = self
        output.insert(contentsOf: StreamMessageAffix.Prefix.sendingMessage, at: startIndex)
        output.insert(contentsOf: StreamMessageAffix.Suffix.endOfMessage, at: endIndex)
        return output.data(using: .utf8)
    }
}
