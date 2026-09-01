import SpriteKit

class PlayerCell: SKNode {
    var shape: SKShapeNode!
    var nameLabel: SKLabelNode!
    var mass: CGFloat = 20 {
        didSet {
            updateScale()
        }
    }
    
    var moveVector: CGPoint = .zero
    var speedBase: CGFloat = 200
    
    init(name: String) {
        super.init()
        
        shape = SKShapeNode(circleOfRadius: 20)
        shape.fillColor = .random()
        shape.strokeColor = .black
        shape.lineWidth = 2
        addChild(shape)
        
        nameLabel = SKLabelNode(text: name)
        nameLabel.fontSize = 12
        nameLabel.fontColor = .white
        nameLabel.verticalAlignmentMode = .center
        addChild(nameLabel)
        
        physicsBody = SKPhysicsBody(circleOfRadius: 20)
        physicsBody?.categoryBitMask = Constants.PhysicsCategory.player
        physicsBody?.contactTestBitMask = Constants.PhysicsCategory.food | Constants.PhysicsCategory.virus | Constants.PhysicsCategory.bot
        physicsBody?.collisionBitMask = Constants.PhysicsCategory.none
        physicsBody?.isDynamic = true
        physicsBody?.linearDamping = 2.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateScale() {
        let radius = sqrt(mass / .pi) * 5
        let scale = radius / 20
        run(SKAction.scale(to: scale, duration: 0.2))
        
        physicsBody = SKPhysicsBody(circleOfRadius: radius)
        physicsBody?.categoryBitMask = Constants.PhysicsCategory.player
        physicsBody?.contactTestBitMask = Constants.PhysicsCategory.food | Constants.PhysicsCategory.virus | Constants.PhysicsCategory.bot
        physicsBody?.collisionBitMask = Constants.PhysicsCategory.none
    }
    
    func update(dt: TimeInterval) {
        let movement = moveVector * speedBase * CGFloat(dt)
        position = position + movement
        
        let halfW = Constants.mapWidth / 2
        let halfH = Constants.mapHeight / 2
        
        position.x = max(-halfW, min(halfW, position.x))
        position.y = max(-halfH, min(halfH, position.y))
    }
}
