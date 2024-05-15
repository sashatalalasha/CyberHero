import SpriteKit

final class ThirdLevelIntroductionScene: SKScene {
    
    var maskNode: SKSpriteNode!
    var cursorNode: SKSpriteNode!
    var cardNode: SKSpriteNode!
    
    var isIntroductionCompleted: Bool = false {
        didSet {
            if(isIntroductionCompleted) {
                let nextScene = ThirdLevelScene(size: self.size)
                view?.presentScene(nextScene, transition: .crossFade(withDuration: 1.0))
            }
        }
    }
    var nodes: [SKSpriteNode] = []
    
    override init(size: CGSize) {
        super.init(size: size)
        self.addBackground()
        self.createBackButton()
        let bubbleNodes = self.createBubbleNode(firstTexture: "3rd_level_introduction_1")
        nodes+=bubbleNodes
        let lanaNode = self.createLanaNode()
        nodes.append(lanaNode)
        
        scaleMode = .fill
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func goToNextText() {
        // if there is such a node, this means the next button after last bubble test was clicked
        if let _ = nodes.first(where: { $0.name == "3rd_level_introduction_2"}){
            fadeOutBubble()
        }
        for node in nodes {
            if node.name == "3rd_level_introduction_1" {
                // replace old introduction with next
                node.texture = SKTexture(imageNamed: "3rd_level_introduction_2.png")
                node.name = "3rd_level_introduction_2"
                node.size = node.texture!.size()
            }
        }
        
    }
    
    func fadeOutBubble() {
        // check if the fade-out action has already been applied
        guard !nodes.contains(where: { $0.alpha == 0 }) else {
            return
        }
        
        let fadeOutAction = SKAction.fadeOut(withDuration: 1.0)
        
        // apply fade-out action to all nodes
        for node in nodes {
            node.run(fadeOutAction)           
        }
        // add hints after all nodes faded out 
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.addPhishingEmailHints()
        }
    }
    func addPhishingEmailHints() {
        // create hints
        let impostorNode = SKSpriteNode(imageNamed: "impostor.png")
        impostorNode.name = "impostor"
        
        let browserWindowNode = SKSpriteNode(imageNamed: "browser_window.png")
        browserWindowNode.name = "browser_window"
        
        cardNode = SKSpriteNode(imageNamed: "credit_card_front.png")
        cardNode.name = "credit_card"
        
        // calculate total width to position components evenly
        let totalWidth = impostorNode.size.width + browserWindowNode.size.width + cardNode.size.width + 200
        var startX = (size.width - totalWidth) / 2
        // get biggest component height to horizontally align labels
        let maxHeight = [impostorNode, browserWindowNode, cardNode].reduce(CGFloat.leastNormalMagnitude) { maxHeight, node in
            return max(maxHeight, node.size.height)
        }
        
        let startY = size.height / 2 - maxHeight / 2
        
        // position and add impostor node with mask and label
        positionHintNode(node: impostorNode, positionX: startX)
        positionMask(parentNode: impostorNode)
        addHintLabelNode(xPosition: startX + impostorNode.size.width / 2, yPosition: startY, index: 1)
        
        // position and add browser window with link, cursor and label
        startX += impostorNode.size.width  + 100
        positionHintNode(node: browserWindowNode, positionX: startX)
        positionLinkComponents(parentNode: browserWindowNode)
        addHintLabelNode(xPosition: startX + browserWindowNode.size.width / 2, yPosition: startY, index: 2)
        
        // position and add carNode with label
        startX += browserWindowNode.size.width + 100
        positionHintNode(node: cardNode, positionX: startX)
        addHintLabelNode(xPosition: startX + cardNode.size.width / 2, yPosition: startY, index: 3)
        
        animateImpostorComponent(node: impostorNode) {
            self.animateLinkComponent() {
                self.animateCardComponent() 
                
                let yPosition = self.frame.midY - maxHeight / 2 - 160
                let updatedYPosition =  self.addInstructionNode(imageNamed: "3rd_level_instruction", yPosition: yPosition)
                self.addStartButtonNode(yPosition: updatedYPosition)
                
                
                
            }
        }
    }
    
    private func positionLinkComponents(parentNode: SKSpriteNode) {
        let linkNode = SKSpriteNode(imageNamed: "link.png")
        // position node in the center of parent Node
        linkNode.position = CGPoint(x: parentNode.position.x + linkNode.size.width , y: parentNode.position.y)
        linkNode.zPosition = 102
        addChild(linkNode)
        nodes.append(linkNode)
        
        cursorNode = SKSpriteNode(imageNamed: "link_cursor.png")
        let bottomRightX = linkNode.position.x + (linkNode.size.width * (1 - linkNode.anchorPoint.x))
        let bottomRightY = linkNode.position.y - (linkNode.size.height * linkNode.anchorPoint.y)
        // position the node in the lower right corner of the text node
        cursorNode.position = CGPoint(x: bottomRightX, y: bottomRightY)
        cursorNode.name = "link_cursor"
        cursorNode.zPosition = 103
        addChild(cursorNode)
        nodes.append(cursorNode)
    }
    
    private func positionHintNode(node: SKSpriteNode, positionX: CGFloat) {
        node.position = CGPoint(x: positionX, y: size.height / 2 + 100)
        node.anchorPoint = CGPoint(x: 0, y: 0.5)
        // set alpha to 0 for fade-in effect later
        node.alpha = 1.0
        addChild(node)
        nodes.append(node)
    }
    
    private func positionMask(parentNode: SKSpriteNode) {
        // Otherwise, create a new maskNode
        maskNode = SKSpriteNode(imageNamed: "impostor_red_mask.png")
        maskNode.position = CGPoint(x: parentNode.position.x + parentNode.size.width / 2,
                                    y: parentNode.position.y + parentNode.size.height / 2 - maskNode.size.height / 2)
        maskNode.name = "impostor_red_mask"
        maskNode.zPosition = 101
        addChild(maskNode)
        nodes.append(maskNode)
    }
    
    
    private func animateImpostorComponent(node: SKSpriteNode, completion: @escaping () -> Void) {
        if let maskNode = maskNode, let faceNode = nodes.first(where: { $0.name == "impostor" }) {
            // Calculate the destination position
            let faceBottomRightX = faceNode.position.x + faceNode.size.width
            let faceBottomRightY = faceNode.position.y - (faceNode.size.height / 2)
            let newPosition = CGPoint(x: faceBottomRightX, y: faceBottomRightY)
            
            // Calculate the movement action
            let moveAction = SKAction.move(to: newPosition, duration: 1.5)
            
            maskNode.run(moveAction) {
                completion() 
            }
            
        }
    }
    
    private func animateLinkComponent(completion: @escaping () -> Void) {
        if let cursorNode = cursorNode, let browserWindowNode = nodes.first(where: { $0.name == "browser_window" }) {
            // calculate the position of the top right corner of the browserNode
            let topRightX = browserWindowNode.position.x + (browserWindowNode.size.width * (1 - browserWindowNode.anchorPoint.x)) - cursorNode.size.width/2
            let topRightY = browserWindowNode.position.y + (browserWindowNode.size.height * (1 - browserWindowNode.anchorPoint.y)) - cursorNode.size.height/2
            let newPosition = CGPoint(x: topRightX, y: topRightY)
            
            let moveAction = SKAction.move(to: newPosition, duration: 1.5)
            
            cursorNode.run(moveAction) {
                completion()
                
            }
            
        }
    }
    
    private func animateCardComponent() {
        let newTexture = SKTexture(imageNamed: "credit_card_back.png")
        cardNode.texture = newTexture
    }
    
    
    private func addHintLabelNode(xPosition: CGFloat, yPosition:CGFloat, index: Int) {
        let textNode = SKSpriteNode(imageNamed: "3rd_level_introduction_label_\(index).png")
        
        textNode.position = CGPoint(x: xPosition, y: yPosition)
        
        textNode.zPosition = 101
        
        addChild(textNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.atPoint(location)
            
            if let nodeName = touchedNode.name {
                switch nodeName {
                case "back_button":
                    // navigate to levels overview if back button is touched
                    let levelsScene = LevelsScene(size: self.size, currentLevel: 3)
                    view?.presentScene(levelsScene, transition: .crossFade(withDuration: 0.5))
                case "start_button":
                    self.isIntroductionCompleted.toggle()
                case "next_button":
                    //  show to next text
                    goToNextText()
                default:
                    break
                }
            }
        }  
    }
}
