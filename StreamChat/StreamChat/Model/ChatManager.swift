
import Foundation

protocol MessageReceivable: class {
    func receive(message: Message?)
}

class ChatManager: NSObject {
    private let bufferSize = 400
    private weak var inputStream: InputStream?
    private weak var outputStream: OutputStream?
    weak var delegate: MessageReceivable?
    
    func connectSocket() {
        Stream.getStreamsToHost(withName: Host.address, port: Host.port, inputStream: &inputStream, outputStream: &outputStream)
        
        guard let inputStream = self.inputStream,
              let outputStream = self.outputStream else {
            return
        }
        
        inputStream.delegate = self
        
        inputStream.schedule(in: .current, forMode: .default)
        outputStream.schedule(in: .current, forMode: .default)
        
        inputStream.open()
        outputStream.open()
    }
    
    func join(with client: Client) {
        let joinMessage = String(describing: SocketDataFormat.join(client.nickname))
        send(message: joinMessage)
    }
    
    func send(message: String) {
        guard let data = message.data(using: .utf8) else {
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
            guard let inputStream  =  aStream as? InputStream else {
                print(aStream.streamError)
                return
            }
            
            var buffer = [UInt8](repeating: 0, count: bufferSize)
            while(inputStream.hasBytesAvailable) {
                handleReceivedMessage(inputStream: inputStream, buffer: &buffer)
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
        }
        
        guard let messageInformation = checkMessageFormat(with: receivedMessage) else {
            return nil
        }
        
        if let messageContent = messageInformation["content"],
           let messageSender = messageInformation["sender"] {
            return ChatMessage(content: messageContent, receivedTime: Date(), sender: messageSender)
        }
        
        return nil
    }
    
    private func checkMessageFormat(with message: String) -> [String : String]? {
        guard message.contains("::") else {
            return nil
        }
        
        guard let sender = message.components(separatedBy: "::").first,
              let content = message.components(separatedBy: "::").last else {
            return nil
        }
        
        let messageInfo = ["sender" : sender, "content": content]
        
        return messageInfo
    }
    
    private func handleReceivedMessage(inputStream: InputStream, buffer: inout [UInt8]) {
        let byteLength = inputStream.read(&buffer, maxLength: bufferSize)
        guard byteLength > 0 else {
            print(inputStream.streamError)
            return
        }
        
        if let receivedMessage = String(bytes: buffer, encoding: .utf8) {
            print(receivedMessage)
            let message: Message? = configureMessage(with: receivedMessage)
            self.delegate?.receive(message: message)
        }
    }
}
fileprivate extension String {
    var isJoinMessage: Bool {
        return hasSuffix(String(describing: SocketDataFormat.userJoined))
    }
    
    var isLeavingMessage: Bool {
        return hasSuffix(String(describing: SocketDataFormat.userLeft))
    }
}
