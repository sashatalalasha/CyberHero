import SpriteKit

class LevelCompletedNode: SKSpriteNode {

    init(parentSize: CGSize) {
        let texture = SKTexture(imageNamed: "level_completed_box.png")
        super.init(texture: texture, color: .clear, size: texture.size())
        self.position = CGPoint(x: parentSize.width/2, y: parentSize.height/2)
        self.zPosition = 100
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    private func configure() {
        // create text node
        let textNode = SKSpriteNode(imageNamed: "level_completed_text.png")
        textNode.position = CGPoint(x: 0, y: 50) 
        textNode.zPosition = 101
        addChild(textNode)
        // create button node
        let buttonNode = SKSpriteNode(imageNamed: "next_button.png")
         buttonNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        buttonNode.position = CGPoint(x: 0, y: -50)  
        buttonNode.zPosition = 101
        addChild(buttonNode)
        buttonNode.name = "next_button"
        
    }
    
}
