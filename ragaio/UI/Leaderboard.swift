import SpriteKit

class Leaderboard: SKNode {
    let title = SKLabelNode(text: "Leaderboard")
    
    override init() {
        super.init()
        
        title.fontSize = 16
        title.fontColor = .black
        addChild(title)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
