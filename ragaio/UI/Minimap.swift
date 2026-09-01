import SpriteKit

class Minimap: SKNode {
    let bg = SKShapeNode(rectOf: CGSize(width: 150, height: 150))
    let playerDot = SKShapeNode(circleOfRadius: 3)
    
    override init() {
        super.init()
        
        bg.fillColor = SKColor.black.withAlphaComponent(0.5)
        bg.strokeColor = .white
        addChild(bg)
        
        playerDot.fillColor = .red
        playerDot.strokeColor = .clear
        addChild(playerDot)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(playerPosition: CGPoint) {
        let normX = playerPosition.x / Constants.mapWidth
        let normY = playerPosition.y / Constants.mapHeight
        
        playerDot.position = CGPoint(x: normX * 150, y: normY * 150)
    }
}
