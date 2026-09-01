import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let player = PlayerCell(name: "Player")
    let cam = SKCameraNode()
    let joystick = Joystick()
    let hud = HUD()
    let minimap = Minimap()
    let leaderboard = Leaderboard()
    
    var lastUpdateTime: TimeInterval = 0
    var foodNodes = [FoodParticle]()
    var botNodes = [AIBot]()
    
    let foodContainer = SKNode()
    
    override func didMove(to view: SKView) {
        backgroundColor = .lightGray
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        // Map bounds
        let mapRect = CGRect(x: -Constants.mapWidth/2, y: -Constants.mapHeight/2, width: Constants.mapWidth, height: Constants.mapHeight)
        let boundsNode = SKShapeNode(rect: mapRect)
        boundsNode.strokeColor = .red
        boundsNode.lineWidth = 10
        addChild(boundsNode)
        
        addChild(foodContainer)
        
        player.position = .zero
        addChild(player)
        
        addChild(cam)
        camera = cam
        
        // UI Overlay
        joystick.position = CGPoint(x: -size.width/2 + 80, y: -size.height/2 + 80)
        joystick.onDirectionChanged = { [weak self] dir in
            self?.player.moveVector = dir
        }
        cam.addChild(joystick)
        
        hud.position = CGPoint(x: -size.width/2 + 20, y: size.height/2 - 40)
        cam.addChild(hud)
        
        minimap.position = CGPoint(x: size.width/2 - 100, y: -size.height/2 + 100)
        cam.addChild(minimap)
        
        leaderboard.position = CGPoint(x: size.width/2 - 80, y: size.height/2 - 50)
        cam.addChild(leaderboard)
        
        spawnInitialFood()
        spawnBots()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime == 0 { lastUpdateTime = currentTime }
        let dt = currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        player.update(dt: dt)
        cam.position = player.position
        
        for bot in botNodes {
            bot.update(dt: dt)
        }
        
        minimap.update(playerPosition: player.position)
        hud.updateScore(Int(player.mass))
        
        // Respawn food
        if foodContainer.children.count < 300 {
            let food = FoodParticle()
            food.position = CGPoint(
                x: .random(min: -Constants.mapWidth/2, max: Constants.mapWidth/2),
                y: .random(min: -Constants.mapHeight/2, max: Constants.mapHeight/2)
            )
            foodContainer.addChild(food)
        }
    }
    
    func spawnInitialFood() {
        for _ in 0..<300 {
            let food = FoodParticle()
            food.position = CGPoint(
                x: .random(min: -Constants.mapWidth/2, max: Constants.mapWidth/2),
                y: .random(min: -Constants.mapHeight/2, max: Constants.mapHeight/2)
            )
            foodContainer.addChild(food)
        }
    }
    
    func spawnBots() {
        for i in 0..<10 {
            let bot = AIBot(name: "Bot \(i)")
            bot.position = CGPoint(
                x: .random(min: -Constants.mapWidth/2, max: Constants.mapWidth/2),
                y: .random(min: -Constants.mapHeight/2, max: Constants.mapHeight/2)
            )
            addChild(bot)
            botNodes.append(bot)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let mask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if mask == Constants.PhysicsCategory.player | Constants.PhysicsCategory.food {
            let playerNode = (contact.bodyA.categoryBitMask == Constants.PhysicsCategory.player) ? contact.bodyA.node as? PlayerCell : contact.bodyB.node as? PlayerCell
            let foodNode = (contact.bodyA.categoryBitMask == Constants.PhysicsCategory.food) ? contact.bodyA.node as? FoodParticle : contact.bodyB.node as? FoodParticle
            
            if let f = foodNode {
                f.removeFromParent()
                playerNode?.mass += 1
            }
        } else if mask == Constants.PhysicsCategory.bot | Constants.PhysicsCategory.food {
            let botNode = (contact.bodyA.categoryBitMask == Constants.PhysicsCategory.bot) ? contact.bodyA.node as? AIBot : contact.bodyB.node as? AIBot
            let foodNode = (contact.bodyA.categoryBitMask == Constants.PhysicsCategory.food) ? contact.bodyA.node as? FoodParticle : contact.bodyB.node as? FoodParticle
            
            if let f = foodNode {
                f.removeFromParent()
                botNode?.mass += 1
            }
        }
    }
}
