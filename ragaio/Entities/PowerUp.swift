import Foundation

enum PowerUpType {
    case speed
    case shield
}

class PowerUp {
    let type: PowerUpType
    
    init(type: PowerUpType) {
        self.type = type
    }
}
