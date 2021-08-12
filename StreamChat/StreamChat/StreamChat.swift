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
    private var username = ""
    private let maxReadLength = 4096

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
        let data = "USR_NAME::\(username)::END"
        self.username = username

        stringToOutputStreamData(string: data)
    }

    func sendChat(message: String) {
        if message.count < 300 {
            let data = "MSG::\(message)::END"

            stringToOutputStreamData(string: data)
        } else {
            print("message limit over")
        }

    }

    private func readChat(stream: InputStream) {
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
        let data = "LEAVE::::END"

        stringToOutputStreamData(string: data)
        inputStream?.close()
        outputStream?.close()
    }
}

extension StreamChat: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .hasBytesAvailable:
            guard let inputStream = aStream as? InputStream else { return }
            readChat(stream: inputStream)
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
                                       freeWhenDone: true)?.components(separatedBy: "::") else { return }
        if stringArray.count == 2 {
            guard let name = stringArray.first,
                  let message = stringArray.last else { return }

            print("\(name) : \(message)")
        } else {
            guard let stringNotification = stringArray.first?.components(separatedBy: " "),
                  let name = stringNotification.first,
                  let joinStatus = stringNotification.last else { return }

            print("\(name) has \(joinStatus)")
        }
    }
}
