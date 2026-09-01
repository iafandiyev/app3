import SpriteKit

class MenuScene: SKScene {
    override func didMove(to view: SKView) {
        setupBackground()
        setupUI()
    }
    
    private func setupBackground() {
        let bg = SKSpriteNode(imageNamed: "menu_bg")
        bg.position = CGPoint(x: size.width / 2, y: size.height / 2)
        bg.size = size
        bg.zPosition = -1
        addChild(bg)
    }
    
    private func setupUI() {
        let titleNode = SKLabelNode(fontNamed: "HelveticaNeue-Bold")
        titleNode.text = "RAGA.IO"
        titleNode.fontSize = 80
        titleNode.fontColor = .white
        titleNode.position = CGPoint(x: size.width / 2, y: size.height / 2 + 100)
        
        // Glow effect
        let glowNode = SKEffectNode()
        glowNode.shouldRasterize = true
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(10.0, forKey: kCIInputRadiusKey)
        glowNode.filter = filter
        
        let titleCopy = titleNode.copy() as! SKLabelNode
        titleCopy.fontColor = .cyan
        glowNode.addChild(titleCopy)
        
        addChild(glowNode)
        addChild(titleNode)
        
        let promptNode = SKLabelNode(fontNamed: "HelveticaNeue-Medium")
        promptNode.text = "Tap to connect & play"
        promptNode.fontSize = 30
        promptNode.fontColor = .lightGray
        promptNode.position = CGPoint(x: size.width / 2, y: size.height / 2 - 50)
        
        let pulseAction = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.5, duration: 0.8),
            SKAction.fadeAlpha(to: 1.0, duration: 0.8)
        ])
        promptNode.run(SKAction.repeatForever(pulseAction))
        addChild(promptNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let transition = SKTransition.crossFade(withDuration: 1.0)
        let gameScene = GameScene(size: size)
        gameScene.scaleMode = .aspectFill
        view?.presentScene(gameScene, transition: transition)
    }
}
