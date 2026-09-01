import SpriteKit

class GameOverScene: SKScene {
    var score: Int = 0
    
    convenience init(size: CGSize, score: Int) {
        self.init(size: size)
        self.score = score
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        
        let lbl = SKLabelNode(text: "Game Over")
        lbl.fontColor = .red
        lbl.fontSize = 50
        lbl.position = CGPoint(x: size.width / 2, y: size.height / 2 + 50)
        addChild(lbl)
        
        let scoreLbl = SKLabelNode(text: "Score: \(score)")
        scoreLbl.fontColor = .black
        scoreLbl.fontSize = 30
        scoreLbl.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(scoreLbl)
        
        let retryBtn = SKLabelNode(text: "Retry")
        retryBtn.name = "retry"
        retryBtn.fontColor = .blue
        retryBtn.fontSize = 30
        retryBtn.position = CGPoint(x: size.width / 2, y: size.height / 2 - 50)
        addChild(retryBtn)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if nodes(at: touch.location(in: self)).contains(where: { $0.name == "retry" }) {
            let menu = MenuScene(size: size)
            menu.scaleMode = .resizeFill
            view?.presentScene(menu, transition: .fade(withDuration: 0.5))
        }
    }
}
