import CoreGraphics
import SpriteKit

extension CGFloat {
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random(in: min...max)
    }
}

extension CGPoint {
    static func +(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    static func -(left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    static func *(point: CGPoint, scalar: CGFloat) -> CGPoint {
        return CGPoint(x: point.x * scalar, y: point.y * scalar)
    }
    
    func length() -> CGFloat {
        return sqrt(x * x + y * y)
    }
    
    func normalized() -> CGPoint {
        let len = length()
        return len > 0 ? CGPoint(x: x / len, y: y / len) : .zero
    }
}

extension SKColor {
    static func random() -> SKColor {
        return SKColor(
            red: .random(in: 0.2...0.8),
            green: .random(in: 0.2...0.8),
            blue: .random(in: 0.2...0.8),
            alpha: 1.0
        )
    }
}
