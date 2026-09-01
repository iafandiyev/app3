import SpriteKit

class AIBot: PlayerCell {
    var targetNode: SKNode?
    var retargetTimer: TimeInterval = 0
    
    override init(name: String) {
        super.init(name: name)
        physicsBody?.categoryBitMask = Constants.PhysicsCategory.bot
        physicsBody?.contactTestBitMask = Constants.PhysicsCategory.food | Constants.PhysicsCategory.player
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(dt: TimeInterval) {
        retargetTimer -= dt
        
        if retargetTimer <= 0 {
            retargetTimer = Double.random(in: 1.0...3.0)
            targetNode = nil
            
            // Random direction if no target
            moveVector = CGPoint(x: .random(min: -1, max: 1), y: .random(min: -1, max: 1)).normalized()
        }
        
        if let target = targetNode, target.parent != nil {
            let dir = target.position - position
            moveVector = dir.normalized()
        }
        
        super.update(dt: dt)
    }
}
