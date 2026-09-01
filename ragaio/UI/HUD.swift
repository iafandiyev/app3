import SpriteKit

class HUD: SKNode {
    let scoreLabel = SKLabelNode(fontNamed: "Helvetica-Bold")
    
    override init() {
        super.init()
        
        scoreLabel.fontSize = 24
        scoreLabel.fontColor = .black
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateScore(_ score: Int) {
        scoreLabel.text = "Score: \(score)"
    }
}
