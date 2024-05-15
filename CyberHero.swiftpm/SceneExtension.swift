import SpriteKit

extension SKScene {
    
    // add background image
    func addBackground() {
        // Add background image
        let backgroundImage = SKSpriteNode(imageNamed: "background.png")
        backgroundImage.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundImage.size = size
        // ensure the background is behind other nodes
        backgroundImage.zPosition = -1 
        addChild(backgroundImage)
        
    }
    
    // add level completed dialog
 func addLevelCompletedDialog() {
        // add blur effect backgorund
        let backgroundNode = SKSpriteNode(color: UIColor(white: 0, alpha: 0.3), size: self.size)
        backgroundNode.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        backgroundNode.zPosition = 99 
        
        self.addChild(backgroundNode)
        
        // add LevelCompletedNode on top of background
        self.addChild(LevelCompletedNode(parentSize: self.size))
    }
    
    // add password generator dialog
    func addPasswordGeneratorDialog() -> PasswordGeneratorNode {
        // add blur effect backgorund
        let backgroundNode = SKSpriteNode(color: UIColor(white: 0, alpha: 0.3), size: self.size)
        backgroundNode.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        backgroundNode.zPosition = 99 
        
        self.addChild(backgroundNode)
        
        // add LevelCompletedNode on top of background
        return PasswordGeneratorNode(parentSize: self.size)
    }
    
    // create lana node
     func createLanaNode() -> SKSpriteNode {
        
        let node = SKSpriteNode(imageNamed: "dog.png")
         let position = CGPoint(x: frame.midX + 400, y: frame.midY - 150)
        node.position = position
        node.name = "dog"
        node.zPosition = 2
        
        self.addChild(node)
         return node
    }
    
    // create bubble node for introduction
    func createBubbleNode(firstTexture: String) -> [SKSpriteNode]{
        // position bubble in the center of the screen
        let bubblePosition = CGPoint(x: frame.midX - 150, y: frame.midY + 150)
        let bubbleNode = SKSpriteNode(imageNamed: "introduction_bubble.png")
        bubbleNode.position = bubblePosition
        bubbleNode.name = "introduction_bubble"
        bubbleNode.zPosition = 2
        addChild(bubbleNode)
        
        // position text inside the bubble
        let textPosition = CGPoint(x: bubbleNode.position.x, y: bubbleNode.position.y  + 40)
        let textNode = SKSpriteNode(imageNamed: "\(firstTexture).png")
        textNode.position = textPosition
        textNode.name = firstTexture
        textNode.zPosition = 3
        addChild(textNode)
        
        // position next button in the lower right corner of the bubble
        let buttonPosition = CGPoint(x: bubbleNode.position.x + 280 ,
                                     y: bubbleNode.position.y - 130)
        let nextButtonNode = SKSpriteNode(imageNamed: "next_button.png")
        nextButtonNode.position = buttonPosition
        nextButtonNode.name = "next_button"
        nextButtonNode.zPosition = 3
        addChild(nextButtonNode)
        
        return [bubbleNode, textNode, nextButtonNode]

    }
    
    func createBackButton() {
        let position = CGPoint(x: frame.minX + 30, y: frame.maxY - 100)
        let node = SKSpriteNode(imageNamed: "back_button.png")
        node.position = position
        node.zPosition = 2
        node.name = "back_button"
        
         self.addChild(node)
    }
    
    // for introduction scenes
    func addStartButtonNode(yPosition: CGFloat) {
        let node = SKSpriteNode(imageNamed: "start_button.png")
        node.position = CGPoint(x: size.width/2, y: yPosition - node.size.width/2 - 20)
        node.name = "start_button"
        // set alpha to 0 for fade in effect
        node.alpha = 0.0
        addChild(node)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.5)
        
        node.run(fadeInAction)
    }
    
    func addInstructionNode(imageNamed: String, yPosition: CGFloat) -> CGFloat {
        let node = SKSpriteNode(imageNamed: "\(imageNamed).png")
        node.position = CGPoint(x: size.width/2, y: yPosition - node.size.height/2 - 20)
        node.name = imageNamed
        // set alpha to 0 for fade in effect
        node.alpha = 1.0
        addChild(node)
        return node.position.y
    }
}
