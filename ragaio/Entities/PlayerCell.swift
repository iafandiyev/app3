import SpriteKit

class PlayerCell: SKNode {
    var radius: CGFloat
    var cellColor: UIColor
    var mass: CGFloat = 30
    
    private var shapeNode: SKShapeNode!
    private var glowNode: SKEffectNode!
    
    init(radius: CGFloat, color: UIColor) {
        self.radius = radius
        self.cellColor = color
        super.init()
        
        setupVisuals()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupVisuals() {
        shapeNode = SKShapeNode(circleOfRadius: radius)
        shapeNode.fillColor = cellColor
        shapeNode.strokeColor = .white
        shapeNode.lineWidth = 2
        
        glowNode = SKEffectNode()
        glowNode.shouldRasterize = true
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(8.0, forKey: kCIInputRadiusKey)
        glowNode.filter = filter
        
        let glowShape = SKShapeNode(circleOfRadius: radius + 5)
        glowShape.fillColor = cellColor
        glowShape.strokeColor = .clear
        glowShape.alpha = 0.6
        glowNode.addChild(glowShape)
        
        addChild(glowNode)
        addChild(shapeNode)
    }
    
    func updateMass(_ newMass: CGFloat) {
        self.mass = newMass
        let newRadius = sqrt(newMass) * 5.0 // scale logic
        
        let scale = newRadius / radius
        run(SKAction.scale(to: scale, duration: 0.2))
    }
}
