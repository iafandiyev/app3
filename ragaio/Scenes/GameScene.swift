import SpriteKit

class GameScene: SKScene, SocketManagerDelegate {
    private var playerNodes: [String: [PlayerCell]] = [:] 
    private var foodNodes: [String: SKShapeNode] = [:]
    private var virusNodes: [String: SKShapeNode] = [:]
    
    private var localPlayerId = UUID().uuidString
    private var localCells: [PlayerCell] = []
    
    private let cameraNode = SKCameraNode()
    private var updateTimer: Timer?
    
    override func didMove(to view: SKView) {
        setupBackground()
        
        camera = cameraNode
        addChild(cameraNode)
        
        // Setup initial local cell
        let startCell = PlayerCell(radius: 30, color: .green)
        startCell.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(startCell)
        localCells.append(startCell)
        
        SocketManager.shared.delegate = self
        SocketManager.shared.connect()
        
        SocketManager.shared.sendMessage(["type": "join", "name": "Player", "id": localPlayerId])
        
        updateTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.sendLocalState()
        }
    }
    
    private func setupBackground() {
        let bgNode = SKSpriteNode(imageNamed: "game_bg")
        bgNode.texture?.filteringMode = .nearest
        bgNode.anchorPoint = .zero
        bgNode.position = CGPoint(x: -3000, y: -3000)
        bgNode.size = CGSize(width: 6000, height: 6000)
        bgNode.zPosition = -10
        addChild(bgNode)
    }
    
    private func sendLocalState() {
        var cellsData: [[String: Any]] = []
        for cell in localCells {
            cellsData.append([
                "x": cell.position.x,
                "y": cell.position.y,
                "mass": cell.mass
            ])
        }
        SocketManager.shared.sendMessage(["type": "update", "id": localPlayerId, "cells": cellsData])
    }
    
    func didConnect() {
        print("Connected to server")
    }
    
    func didDisconnect() {
        print("Disconnected from server")
    }
    
    func didReceiveState(players: [String : Any], food: [[String : Any]], viruses: [[String : Any]]) {
        // Sync players
        for (id, data) in players {
            guard id != localPlayerId else { continue }
            if let playerData = data as? [String: Any], let cells = playerData["cells"] as? [[String: Any]] {
                if playerNodes[id] == nil {
                    playerNodes[id] = []
                }
                
                while playerNodes[id]!.count < cells.count {
                    let newCell = PlayerCell(radius: 30, color: .red)
                    addChild(newCell)
                    playerNodes[id]!.append(newCell)
                }
                
                for (index, cellData) in cells.enumerated() {
                    if let x = cellData["x"] as? CGFloat, let y = cellData["y"] as? CGFloat, let mass = cellData["mass"] as? CGFloat {
                        let node = playerNodes[id]![index]
                        node.position = CGPoint(x: x, y: y)
                        node.updateMass(mass)
                    }
                }
            }
        }
        
        // Render food
        for f in food {
            if let fId = f["id"] as? String, let x = f["x"] as? CGFloat, let y = f["y"] as? CGFloat {
                if foodNodes[fId] == nil {
                    let fn = SKShapeNode(circleOfRadius: 5)
                    fn.fillColor = .yellow
                    fn.position = CGPoint(x: x, y: y)
                    addChild(fn)
                    foodNodes[fId] = fn
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let mainCell = localCells.first else { return }
        let location = touch.location(in: self)
        
        let dx = location.x - mainCell.position.x
        let dy = location.y - mainCell.position.y
        let angle = atan2(dy, dx)
        let speed: CGFloat = 5.0
        
        mainCell.position.x += cos(angle) * speed
        mainCell.position.y += sin(angle) * speed
        
        cameraNode.position = mainCell.position
        
        checkFoodCollisions(for: mainCell)
    }
    
    private func checkFoodCollisions(for cell: PlayerCell) {
        var eatenFoodIds: [String] = []
        for (fId, foodNode) in foodNodes {
            let distance = hypot(cell.position.x - foodNode.position.x, cell.position.y - foodNode.position.y)
            if distance < cell.radius {
                eatenFoodIds.append(fId)
                foodNode.removeFromParent()
                cell.updateMass(cell.mass + 1)
            }
        }
        
        for fId in eatenFoodIds {
            foodNodes.removeValue(forKey: fId)
            SocketManager.shared.sendMessage(["type": "eatFood", "id": fId])
        }
    }
    
    func splitLocalPlayer() {
        guard localCells.first != nil else { return }
        // Implement split logic visually
    }
    
    func ejectMass() {
        guard let mainCell = localCells.first else { return }
        SocketManager.shared.sendMessage([
            "type": "eject",
            "id": localPlayerId,
            "x": mainCell.position.x,
            "y": mainCell.position.y,
            "color": "green"
        ])
    }
}
