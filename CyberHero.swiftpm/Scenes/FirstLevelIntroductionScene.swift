import SpriteKit

final class FirstLevelIntroductionScene: SKScene {
    
    var lock1: SKSpriteNode!
    var lock2: SKSpriteNode!
    var lock3: SKSpriteNode!
    
    var nodes: [SKSpriteNode] = []
    
    override init(size: CGSize) {
        
        super.init(size: size)
        self.addBackground()
        self.createBackButton()
        let bubbleNodes = self.createBubbleNode(firstTexture: "introduction_1_level_1")
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
        if let _ = nodes.first(where: { $0.name == "introduction_2_level_1"}){
            fadeOutBubble()
        }
        for node in nodes {
            if node.name == "introduction_1_level_1" {
                // replace old introduction with next
                node.texture = SKTexture(imageNamed: "introduction_2_level_1.png")
                node.name = "introduction_2_level_1"
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
        // add password recipe after all nodes faded out
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            self.addPasswordRecipe()
        }
    }
    
    func addPasswordRecipe() {
        // create locks
        lock1 = SKSpriteNode(imageNamed: "lock_1.png")
        lock1.name = "lock_1"
        
        lock2 = SKSpriteNode(imageNamed: "lock_1.png")
        lock2.name = "lock_2"
        
        lock3 = SKSpriteNode(imageNamed: "lock_1.png")
        lock3.name = "lock_3"
        
        // calculate total width to position locks evenly
        let totalWidth = lock1.size.width + lock2.size.width + lock3.size.width + 160
        var startX = (size.width - totalWidth) / 2
        
        // position and add lock1 with its text
        positionLockNode(node: lock1, positionX: startX)
        addChild(lock1)
        addLockLabelNode(parentNode: lock1, lockIndex: 1)
        
        // position and add lock2 with its text
        startX += lock1.size.width + 80
        positionLockNode(node: lock2, positionX: startX)
        addChild(lock2)
        addLockLabelNode(parentNode: lock2, lockIndex: 2)
        
        // position and add lock3 with its text
        startX += lock2.size.width + 80
        positionLockNode(node: lock3, positionX: startX)
        addChild(lock3)
        addLockLabelNode(parentNode: lock3, lockIndex: 3)
        
        // animate all locks and their labels
        animateLockComponent(node: lock1) {
            // on complete, animate lock2
            self.animateLockComponent(node: self.lock2) {
                // on complete, animate lock3
                self.animateLockComponent(node: self.lock3) {
                    // on complete, show instruction  and start button
                    let yPosition = self.lock3.position.y - self.lock3.size.height / 2 - 160
                    let updatedYPosition =  self.addInstructionNode(imageNamed: "1st_level_instruction", yPosition: yPosition)
                    self.addStartButtonNode(yPosition: updatedYPosition)
                }
            }
        }
    }
    
    private func positionLockNode(node: SKSpriteNode, positionX: CGFloat) {
        node.position = CGPoint(x: positionX, y: size.height / 2 + 100)
        node.anchorPoint = CGPoint(x: 0, y: 0.5)
        // set alpha to 0 for fade-in effect later
        node.alpha = 0.0
    }
    
    private func animateLockComponent(node: SKSpriteNode, completion: @escaping () -> Void) {
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.5)
        
        var textures: [SKTexture] = []
        
        // create textures for animation
        for index in 2...8 {
            let texture = SKTexture(imageNamed: "lock_\(index)")
            textures.append(texture)
        }
        
        let animation = SKAction.animate(with: textures, timePerFrame: 0.05)
        
        let lockSequence = SKAction.sequence([fadeInAction, animation])
        
        // get the first child of the parent node
        let textNode = node.children.first
        textNode?.run(fadeInAction)
        
        // run animation
        node.run(lockSequence) {
            // on complete, execute completion function
            completion()
        }
    }
    
    
    private func addLockLabelNode(parentNode: SKSpriteNode, lockIndex: Int) {
        let textNode = SKSpriteNode(imageNamed: "lock_label_\(lockIndex).png")
        
        // x value to place the text node in the center
        let offsetX =  parentNode.size.width / 2
        
        // y value to place the text node below the parent node
        let offsetY = -parentNode.size.height / 2 - textNode.size.height / 2 - 20
        
        textNode.position = CGPoint(x: offsetX, y: offsetY)
        
        textNode.zPosition = 100
        
        // set alpha to 0 for future fade-in effect
        textNode.alpha = 0.0
        
        parentNode.addChild(textNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.atPoint(location)
            
            if let nodeName = touchedNode.name {
                switch nodeName {
                case "back_button":
                    let previousScene = LevelsScene(size: self.size, currentLevel: 1)
                    view?.presentScene(previousScene, transition: .crossFade(withDuration: 0.5))
                case "start_button":
                    let nextScene = FirstLevelScene(size: self.size)
                    view?.presentScene(nextScene, transition: .crossFade(withDuration: 0.5))
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
