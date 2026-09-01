import SpriteKit

class FoodParticle: SKNode {
    let shape: SKShapeNode
    
    override init() {
        let radius: CGFloat = 5
        shape = SKShapeNode(circleOfRadius: radius)
        shape.fillColor = .random()
        shape.strokeColor = .clear
        
        super.init()
        addChild(shape)
        
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody?.categoryBitMask = Constants.PhysicsCategory.food
        physicsBody?.contactTestBitMask = Constants.PhysicsCategory.player | Constants.PhysicsCategory.bot
        physicsBody?.collisionBitMask = Constants.PhysicsCategory.none
        physicsBody?.isDynamic = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
