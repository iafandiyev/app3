import Foundation
import Starscream

protocol SocketManagerDelegate: AnyObject {
    func didReceiveState(players: [String: Any], food: [[String: Any]], viruses: [[String: Any]])
}

class SocketManager: WebSocketDelegate {
    static let shared = SocketManager()
    weak var delegate: SocketManagerDelegate?
    var socket: WebSocket!
    var isConnected = false
    
    private init() {
        var request = URLRequest(url: URL(string: "ws://127.0.0.1:3000")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
    }
    
    func connect() {
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    func sendMessage(_ dict: [String: Any]) {
        guard isConnected else { return }
        if let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
           let string = String(data: data, encoding: .utf8) {
            socket.write(string: string)
        }
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocketClient) {
        switch event {
        case .connected(_):
            isConnected = true
            print("Connected to server")
        case .disconnected(_, _):
            isConnected = false
            print("Disconnected from server")
        case .text(let string):
            handleMessage(string)
        default:
            break
        }
    }
    
    private func handleMessage(_ text: String) {
        guard let data = text.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return
        }
        
        let type = json["type"] as? String
        
        if type == "state" {
            let players = json["players"] as? [String: Any] ?? [:]
            let food = json["food"] as? [[String: Any]] ?? []
            let viruses = json["viruses"] as? [[String: Any]] ?? []
            
            DispatchQueue.main.async {
                self.delegate?.didReceiveState(players: players, food: food, viruses: viruses)
            }
        }
    }
}
