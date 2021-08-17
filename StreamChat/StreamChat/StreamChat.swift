//
//  StreamChat.swift
//  StreamChat
//
//  Created by 기원우 on 2021/08/12.
//

import Foundation

final class StreamChat: NSObject {
    private var inputStream: InputStream?
    private var outputStream: OutputStream?

    private let maxReadLength = 4096
    private let maxSendMessageLength = 300
    private let receiveMessageCount = 2
    private var username: String
    private var chats: [Chat] = [Chat(username: "우디", message: "메시지지롱", identifier: .my, date: Date()),
                                 Chat(username: "스티븐", message: "그저 디코에서 보였을 뿐", identifier: .other, date: Date()),
                                 Chat(username: "우디", message: "잘 됐으면", identifier: .my, date: Date())]

    init(username: String) {
        self.username = username
    }

    func setupNetworkCommunication() {
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?

        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           StreamInfomation.host,
                                           StreamInfomation.port,
                                           &readStream,
                                           &writeStream)

        inputStream = readStream?.takeRetainedValue()
        outputStream = writeStream?.takeRetainedValue()

        inputStream?.delegate = self
        inputStream?.schedule(in: .current, forMode: .common)
        outputStream?.schedule(in: .current, forMode: .common)

        inputStream?.open()
        outputStream?.open()
    }

    private func stringToOutputStreamData(string: String) {
        guard let data = string.data(using: .utf8) else { return }

        data.withUnsafeBytes {
            guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else { return }
            outputStream?.write(pointer, maxLength: data.count)
        }
    }

    func joinChat(username: String) {
        let data = StreamDataFormat.shared.join(data: username)
        self.username = username

        stringToOutputStreamData(string: data)
    }

    func sendChat(message: String) {
        if message.count < maxSendMessageLength {
            let data = StreamDataFormat.shared.sendMessage(data: message)

            stringToOutputStreamData(string: data)
            chats.append(Chat(username: username,
                              message: message,
                              identifier: .my,
                              date: Date()))
        } else {
            print("message limit over")
        }
    }

    private func receiveChat(stream: InputStream) {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxReadLength)

        while stream.hasBytesAvailable {
            guard let numberOfBytesRead = inputStream?.read(buffer,
                                                            maxLength: maxReadLength) else { return }

            if numberOfBytesRead < 0, let error = stream.streamError {
                print(error)
                break
            }

            processedMessagedString(buffer: buffer, length: numberOfBytesRead)
        }
    }

    func stopChat() {
        let data = StreamDataFormat.shared.leave()

        stringToOutputStreamData(string: data)
        inputStream?.close()
        outputStream?.close()
    }

    func countChats() -> Int {
        return chats.count
    }

    func readChats(at index: Int) -> Chat {
        return chats[index]
    }
}

extension StreamChat: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .hasBytesAvailable:
            guard let inputStream = aStream as? InputStream else { return }
            receiveChat(stream: inputStream)
        case .endEncountered:
            stopChat()
        default:
            print("unknown Event")
        }
    }

    private func processedMessagedString(buffer: UnsafeMutablePointer<UInt8>, length: Int) {
        guard let stringArray = String(bytesNoCopy: buffer,
                                       length: length,
                                       encoding: .utf8,
                                       freeWhenDone: true)?.components(separatedBy: StreamDataFormat.shared.divisionPoint) else { return }

        if stringArray.count == receiveMessageCount {
            guard let username = stringArray.first,
                  let message = stringArray.last else { return }

            // TODO: - 메시지 수신 오브젝트 생성 및 출력
            print(StreamDataFormat.shared.receiveMessage(username: username, message: message))
        } else {
            guard let stringNotification = stringArray.first?.components(separatedBy: StreamDataFormat.shared.divisionSpaceNotifi),
                  let username = stringNotification.first,
                  let status = stringNotification.last else { return }

            // TODO: - 타인의 채팅 참가, 중간 여부에 따른 알림 생성 및 출력
            print(StreamDataFormat.shared.othreUserChatStatus(username: username, status: status))
        }
    }
}
