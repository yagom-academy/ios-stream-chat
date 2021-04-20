
import Foundation

class ChatManager: NSObject, StreamDelegate {    
    private var inputStream: InputStream?
    private var outputStream: OutputStream?
    
    func connectSocket() {
        Stream.getStreamsToHost(withName: Host.address, port: Host.port, inputStream: &inputStream, outputStream: &outputStream)
        
        guard let inputStream = self.inputStream,
              let outputStream = self.outputStream else {
            return
        }
        
        let myRunLoop = RunLoop.current
        inputStream.schedule(in: myRunLoop, forMode: .default)
        inputStream.delegate = self
        
        inputStream.open()
        outputStream.open()
        
        print("current ip : \(Host.address)")
    }
}
