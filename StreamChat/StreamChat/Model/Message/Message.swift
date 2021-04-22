import Foundation

protocol Message {
    var content: String { get }
    var receivedTime: Date { get }
}
