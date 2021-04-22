
import Foundation

protocol MessageReceivable: class {
    func receive(message: Message?)
}

class ChatManager: NSObject {
    let bufferSize = 400
    var inputStream: InputStream?
    var outputStream: OutputStream?
    weak var delegate: MessageReceivable?
    
    func connectSocket() {
        Stream.getStreamsToHost(withName: Host.address, port: Host.port, inputStream: &inputStream, outputStream: &outputStream)
        
        guard let inputStream = self.inputStream,
              let outputStream = self.outputStream else {
            return
        }
        
        inputStream.delegate = self

        let runLoop = RunLoop.current
        inputStream.schedule(in: runLoop, forMode: .default)
        outputStream.schedule(in: runLoop, forMode: .default)
        
        inputStream.open()
        outputStream.open()
    }
    
    func join(with client: Client) {
        let joinMessage = String(describing: SocketDataFormat.join(client.nickname))
        guard let data = joinMessage.data(using: .utf8) else {
            return
        }
        
        writeOnOutputStream(with: data)
    }
    
    func send(message: String) {
        let sendingMessage = String(describing: SocketDataFormat.send(message))
        guard let data = sendingMessage.data(using: .utf8) else {
            return
        }
        
        writeOnOutputStream(with: data)
    }
    
    func closeSocket() {
        guard let inputStream = self.inputStream,
              let outputStream = self.outputStream else {
            return
        }
        
        inputStream.close()
        outputStream.close()
    }
}
extension ChatManager: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .hasBytesAvailable:
            let inputStream  =  aStream as! InputStream
            var buffer = [UInt8](repeating: 0, count: bufferSize)
            while(inputStream.hasBytesAvailable) {
                let byteLength = inputStream.read(&buffer, maxLength: bufferSize)
                guard byteLength > 0 else {
                    print(inputStream.streamError)
                    return
                }
                
                if let receivedMessage = String(bytes: buffer, encoding: .utf8) {
                    let message: Message? = configureMessage(with: receivedMessage)
                    self.delegate?.receive(message: message)
                }
                
            }
        case .endEncountered:
            closeSocket()
        default:
            print("waiting...")
        }
    }
}
extension ChatManager {
    private func writeOnOutputStream(with data: Data) {
        data.withUnsafeBytes {
            guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                print("Error")
                return
            }
            
            if let outputStream = self.outputStream {
                outputStream.write(pointer, maxLength: data.count)
            }
        }
    }
    
    private func configureMessage(with receivedMessage: String) -> Message? {
        let receivedMessage = receivedMessage.replacingOccurrences(of: "\0", with: "")
        
        if receivedMessage.isJoinMessage || receivedMessage.isLeavingMessage {
            return AlarmMessage(content: receivedMessage, receivedTime: Date())
        } else if receivedMessage.components(separatedBy: "::").count == 2 {
            let messageInfo = receivedMessage.components(separatedBy: "::")
            let (sender, content) = (messageInfo[0],messageInfo[1])
            return ChatMessage(content: content, receivedTime: Date(), sender: sender)
        }
        
        return nil
    }
}
extension String {
    var isJoinMessage: Bool {
        return hasSuffix("has joined\n")
    }
    
    var isLeavingMessage: Bool {
        return hasSuffix("has left\n")
    }
}
