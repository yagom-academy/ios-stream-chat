import Foundation

protocol StreamConnection {
    init(address: String, port: UInt32)
    func inputStreamConnection() -> InputStream
    func outputStreamConnection() -> OutputStream
}

final class ChatNetwork {
    private var inputStream: InputStream!
    private var outputStream: OutputStream!
    private var username = ""
    private let maxMessageLength = 300
    private let streamDelegate = StreamEventHandler()
    
    init(username: String) {
        let serverAddress = "stream-ios.yagom-academy.kr"
        let serverPort: UInt32 = 7748
        self.username = username
        
        let streamConnection: StreamConnection = HostStreamConnection(address: serverAddress, port: serverPort)

        inputStream = streamConnection.inputStreamConnection()
        outputStream = streamConnection.outputStreamConnection()
        
        streamDelegate.delegate = self
        inputStream.delegate = streamDelegate
        
        inputStream.open()
        outputStream.open()
    }
    
    func connectChat(completionHandler: (Result<Int, NetworkError>) -> Void) {
        let chatConnectionMessage = ChatConnectionMessage()
        let joinMessage = chatConnectionMessage.createJoinMessageFormat(username: username)
    
        joinMessage.withUnsafeBytes { (unsafeRawBufferPointer) in
            guard let message = unsafeRawBufferPointer.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                return
            }
            
            let result = outputStream.write(message, maxLength: joinMessage.count)
            if result < 0 {
                completionHandler(.failure(.connectionFail))
            }
        }
    }
}

extension ChatNetwork: MessageEventDelegate {
    func readMessage(stream: InputStream) {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxMessageLength)
        let readBytes = inputStream.read(buffer, maxLength: maxMessageLength)

        guard let messages = String(bytesNoCopy: buffer, length: readBytes, encoding: .utf8, freeWhenDone: true) else {
            return
        }

        print(messages)
    }
}
