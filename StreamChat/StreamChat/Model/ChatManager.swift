
import Foundation

protocol MessageReceivable: class {
    func receive(message: Message?)
}

class ChatManager: NSObject {
    private let socketResponseChecker = SocketResponseChecker()
    
    private var inputStream: InputStream!
    private var outputStream: OutputStream!
    weak var delegate: MessageReceivable?
    
    private var readStream: Unmanaged<CFReadStream>?
    private var writeStream: Unmanaged<CFWriteStream>?
    
    func connectSocket() {
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,  Host.address as  CFString, Host.port, &readStream,  &writeStream)
        
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        
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
            
            while(inputStream.hasBytesAvailable) {
                if let message = socketResponseChecker.handleReceivedMessage(inputStream: inputStream) {
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
}
