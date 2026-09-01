import SpriteKit

class Virus: SKNode {
    let shape: SKShapeNode
    
    override init() {
        let radius: CGFloat = 30
        shape = SKShapeNode(circleOfRadius: radius)
        shape.fillColor = .green
        shape.strokeColor = .green
        
        super.init()
        addChild(shape)
        
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody?.categoryBitMask = Constants.PhysicsCategory.virus
        physicsBody?.contactTestBitMask = Constants.PhysicsCategory.player | Constants.PhysicsCategory.bot
        physicsBody?.collisionBitMask = Constants.PhysicsCategory.none
        physicsBody?.isDynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
