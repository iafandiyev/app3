import CoreGraphics

struct Constants {
    struct PhysicsCategory {
        static let none: UInt32 = 0
        static let player: UInt32 = 0b1
        static let food: UInt32 = 0b10
        static let virus: UInt32 = 0b100
        static let bot: UInt32 = 0b1000
    }
    
    static let mapWidth: CGFloat = 6000
    static let mapHeight: CGFloat = 6000
}
