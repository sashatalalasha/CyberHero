import SpriteKit

final class IntroductionScene: SKScene {
    
    var nodes: [SKSpriteNode] = []
    
    override init(size: CGSize) {
        super.init(size: size)
        self.addBackground()
        let bubbleNodes = self.createBubbleNode(firstTexture: "introduction_text_1")
        nodes+=bubbleNodes
        let lanaNode = self.createLanaNode()
        nodes.append(lanaNode)
        
        scaleMode = .fill
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func goToNextText() {
        // Iterate through child nodes
        for node in nodes {
            // Check if the node has the specified name
            if node.name == "next_button" {
                // Replace next button with start button
                node.texture = SKTexture(imageNamed: "start_button.png")
                node.name = "start_button" 
            } 
            if node.name == "introduction_text_1" {
                // replace introduction text with the next one
                node.texture = SKTexture(imageNamed: "introduction_text_2.png")
                node.name = "introduction_text_2"
                node.size = node.texture!.size() 
                
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let node = self.atPoint(touch.location(in: self))
        if node.name == "next_button" {
            goToNextText()
        } else if node.name == "start_button" {
            let nextScene = LevelsScene(size: self.size, currentLevel: 1)
            view?.presentScene(nextScene, transition: .crossFade(withDuration: 1.0))
        }
        
    }
    
}
