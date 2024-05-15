
import SpriteKit

class EmailNode {
    var isDraggable: Bool
    var node: SKSpriteNode
    var startPosition: CGPoint
    
    init(isDraggable: Bool, node: SKSpriteNode, startPosition: CGPoint) {
        self.isDraggable = isDraggable
        self.node = node
        self.startPosition = startPosition
    }
}
