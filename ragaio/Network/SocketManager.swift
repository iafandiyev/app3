import Foundation

protocol SocketManagerDelegate: AnyObject {
    func didReceiveState(players: [String: Any], food: [[String: Any]], viruses: [[String: Any]])
    func didConnect()
    func didDisconnect()
}

class SocketManager {
    static let shared = SocketManager()
    
    private var webSocketTask: URLSessionWebSocketTask?
    weak var delegate: SocketManagerDelegate?
    private let url = URL(string: "ws://127.0.0.1:3000")!
    
    private init() {}
    
    func connect() {
        let session = URLSession(configuration: .default)
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        receiveMessage()
        delegate?.didConnect()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        delegate?.didDisconnect()
    }
    
    func sendMessage(_ dict: [String: Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
              let string = String(data: data, encoding: .utf8) else {
            return
        }
        
        let message = URLSessionWebSocketTask.Message.string(string)
        webSocketTask?.send(message) { error in
            if let error = error {
                print("WebSocket sending error: \(error)")
            }
        }
    }
    
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("WebSocket receiving error: \(error)")
                self?.delegate?.didDisconnect()
            case .success(let message):
                switch message {
                case .string(let text):
                    self?.handleIncomingMessage(text)
                case .data(let data):
                    if let text = String(data: data, encoding: .utf8) {
                        self?.handleIncomingMessage(text)
                    }
                @unknown default:
                    break
                }
                self?.receiveMessage()
            }
        }
    }
    
    private func handleIncomingMessage(_ text: String) {
        guard let data = text.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return
        }
        
        if let type = json["type"] as? String, type == "state" {
            let players = json["players"] as? [String: Any] ?? [:]
            let food = json["food"] as? [[String: Any]] ?? []
            let viruses = json["viruses"] as? [[String: Any]] ?? []
            
            DispatchQueue.main.async {
                self?.delegate?.didReceiveState(players: players, food: food, viruses: viruses)
            }
        }
    }
}
