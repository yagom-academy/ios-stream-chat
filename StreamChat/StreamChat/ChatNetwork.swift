import Foundation

final class ChatNetwork: NSObject {
    private var inputStream: InputStream!
    private var outputStream: OutputStream!
    private let username = "3pro😎"
    private let maxMessageLength = 300
    
    func setupNetwork() {
        let serverAddress = "stream-ios.yagom-academy.kr" as CFString
        let serverPort: UInt32 = 80
        
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, serverAddress, serverPort, &readStream, &writeStream)
        
        inputStream = readStream?.takeRetainedValue()
        outputStream = writeStream?.takeRetainedValue()
        
        inputStream.schedule(in: .current, forMode: .common)
        outputStream.schedule(in: .current, forMode: .common)
        
        inputStream.open()
        outputStream.open()
    }
}
