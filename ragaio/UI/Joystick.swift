import SpriteKit

class Joystick: SKNode {
    let outerCircle = SKShapeNode(circleOfRadius: 50)
    let innerKnob = SKShapeNode(circleOfRadius: 20)
    
    var onDirectionChanged: ((CGPoint) -> Void)?
    var isTracking = false
    
    override init() {
        super.init()
        
        outerCircle.fillColor = SKColor.gray.withAlphaComponent(0.5)
        outerCircle.strokeColor = .clear
        addChild(outerCircle)
        
        innerKnob.fillColor = SKColor.darkGray
        innerKnob.strokeColor = .clear
        addChild(innerKnob)
        
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTracking = true
        updateKnob(touches.first!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isTracking {
            updateKnob(touches.first!)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTracking = false
        innerKnob.position = .zero
        onDirectionChanged?(.zero)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
    
    private func updateKnob(_ touch: UITouch) {
        let loc = touch.location(in: self)
        var dir = loc
        let len = dir.length()
        
        if len > 50 {
            dir = dir.normalized() * 50
        }
        
        innerKnob.position = dir
        
        let normalizedDir = dir.normalized()
        onDirectionChanged?(normalizedDir)
    }
}
