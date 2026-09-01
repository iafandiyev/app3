import SpriteKit

class MenuScene: SKScene {
    override func didMove(to view: SKView) {
        backgroundColor = .white
        
        let title = SKLabelNode(text: "raga.io")
        title.fontColor = .black
        title.fontSize = 60
        title.position = CGPoint(x: size.width / 2, y: size.height / 2 + 50)
        addChild(title)
        
        let playBtn = SKLabelNode(text: "Play")
        playBtn.name = "play"
        playBtn.fontColor = .blue
        playBtn.fontSize = 40
        playBtn.position = CGPoint(x: size.width / 2, y: size.height / 2 - 50)
        addChild(playBtn)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let nodesAtTouch = nodes(at: touch.location(in: self))
        
        for node in nodesAtTouch {
            if node.name == "play" {
                let gameScene = GameScene(size: size)
                gameScene.scaleMode = .resizeFill
                view?.presentScene(gameScene, transition: .crossFade(withDuration: 0.5))
            }
        }
    }
}
