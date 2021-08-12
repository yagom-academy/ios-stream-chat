//
//  StreamChat.swift
//  StreamChat
//
//  Created by 기원우 on 2021/08/12.
//

import Foundation

class StreamChat: NSObject {
    private var inputStream: InputStream?
    private var outputStream: OutputStream?
    private var username = ""
    private let maxReadLength = 4096

    func setupNetworkComunication() {
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?

        // todo : host, port 값 외부 참조화 필요
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           "15.165.55.224" as CFString,
                                           5080,
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

    func stringToOutputStreamData(string: String) {
        guard let data = string.data(using: .utf8) else { return }

        data.withUnsafeBytes {
            guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else { return }
            outputStream?.write(pointer, maxLength: data.count)
        }
    }

    func joinChat(username: String) {
        print("join start")
        let data = "USR_NAME::\(username)::END"
        self.username = username

        stringToOutputStreamData(string: data)
    }

    func sendChat(message: String) {
        print("send Message")
        let data = "MSG::\(message)::END"

        stringToOutputStreamData(string: data)
    }

    func stopChat() {
        print("leave Stream Chat")
        let data = "LEAVE::::END"

        stringToOutputStreamData(string: data)
        inputStream?.close()
        outputStream?.close()
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

            // message object
            processedMessagedString(buffer: buffer, length: numberOfBytesRead)
        }
    }
}

extension StreamChat: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .hasBytesAvailable:
            print("새로운 메시지를 받았습니다.")
//            guard let inputStream = aStream as? InputStream else { return }
            readChat(stream: aStream as! InputStream)
        case .endEncountered:
            print("채팅을 종료합니다")
            stopChat()
        default:
            print("알 수 없는 이벤트")
        }
    }
    
    private func processedMessagedString(buffer: UnsafeMutablePointer<UInt8>, length: Int) {
        guard let stringArray = String(bytesNoCopy: buffer,
                                       length: length,
                                       encoding: .utf8,
                                       freeWhenDone: true)?.components(separatedBy: "::"),
              let name = stringArray.first,
              let message = stringArray.last else { return }

        print("\(name) : \(message)")
    }
}
