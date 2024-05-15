import SpriteKit

final class FirstLevelScene: SKScene {
    
    var isLevelCompleted: Bool = false {
        didSet {
            // show level completed dialog when a correct answer is selected
            if isLevelCompleted {
                self.addLevelCompletedDialog()
            }
        }
    }
    var isTouchEnabled: Bool  = true {
        didSet {
            // when wrong answer is selected, enable touch in 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                
                self.isTouchEnabled = true
                
            }
        }
    }
    var correctAnswer: String  =  "first_question_answer_1_1"
    var nodes: [SKSpriteNode] = []
    
    override init(size: CGSize) {
        super.init(size: size)
        self.addBackground()
        self.createBackButton()
        let lanaNode = self.createLanaNode()
        nodes.append(lanaNode)
        createMatrixOfSprites()
        createQuestionNode()
        
        scaleMode = .fill
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createQuestionNode(){
        
        let position = CGPoint(x: frame.midX + 50, y: frame.midY + 230)
        let node = SKSpriteNode(imageNamed: "first_question.png")
        node.position = position
        node.name = "first_question"
        node.zPosition = 2
        
        addChild(node)
        nodes.append(node)
    }
    
    private func createMatrixOfSprites() {
        
        var spriteSize: CGSize;
        
        let image = UIImage(named: "default_answer.png")!
        spriteSize = image.size
        
        // spacing between nodes
        let spacing = 20.0
        
        // calculate the total width and height of the matrix
        let totalWidth = (spriteSize.width + spacing) * 2
        let totalHeight = (spriteSize.height + spacing) * 2
        
        // starting position for the top-left sprite node
        let startX = frame.midX - totalWidth
        let startY = frame.midY - totalHeight
        
        // loop through matrix to add nodes
        for row in 1..<3 {
            for col in 1..<3 {
                // position for the current sprite node
                let x = startX + CGFloat(col) * (spriteSize.width + spacing)
                let y = startY + CGFloat(row) * (spriteSize.height + spacing)
                // create answer box node
                let boxNode = SKSpriteNode(imageNamed: "default_answer.png")
                boxNode.position = CGPoint(x: x, y: y)
                boxNode.name = "first_question_answer_\(row)_\(col)_box"
                boxNode.zPosition = 2
                addChild(boxNode)
                nodes.append(boxNode)
                
                // add text for answer
                let textNode = SKSpriteNode(imageNamed: "first_question_answer_\(row)_\(col).png")
                textNode.position = CGPoint(x: x, y: y)
                textNode.name = "first_question_answer_\(row)_\(col)"
                textNode.zPosition = 3
                addChild(textNode)
            }
        }
    }
    
    
    private func createLanaNode(size: CGSize){
        
        let position = CGPoint(x: frame.midX, y: frame.midY + 200)
        let node = SKSpriteNode(imageNamed: "go_button.png")
        node.position = position
        node.zPosition = 2
        node.name = "go_button"
        
        addChild(node)
        nodes.append(node)
    }
    
    // change texture of a node for 2 seconds
    private func changeTextureNode(node: SKSpriteNode, wrongTexture: String, defaultTexture: String) {
        // actions to be performed on a node
        let waitAction = SKAction.wait(forDuration: 2.0)
        
        // change texture of node when the answer was wrong
        let changeWrongTextureAction = SKAction.run {
            
            node.texture = SKTexture(imageNamed: wrongTexture)
        }
        
        // change texture to default
        let changeDefaultTextureAction = SKAction.run {
            
            node.texture = SKTexture(imageNamed: defaultTexture)
        }
        // add actions to node
        node.run(SKAction.sequence([changeWrongTextureAction, waitAction, changeDefaultTextureAction]))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // process touches only if touch interaction is enabled
        guard isTouchEnabled else {
            return
        }
        
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.atPoint(location)
            
            if let nodeName = touchedNode.name {
                switch nodeName {
                case "back_button":
                    // navigate to levels overview if back button is touched
                    let previousScene = LevelsScene(size: self.size, currentLevel: 1)
                    view?.presentScene(previousScene, transition: .crossFade(withDuration: 0.5))
                case "next_button":
                    // navigate to levels overview if current level is completed
                    if isLevelCompleted {
                        let levelsScene = LevelsScene(size: self.size, currentLevel: 2)
                        view?.presentScene(levelsScene, transition: .crossFade(withDuration: 0.5))
                    }
                default:
                    
                    // check if the touched node corresponds to a correct answer
                    if nodeName.contains(correctAnswer) {
                        // change answer box to green for correct answer
                        for answerBox in nodes where answerBox.name?.contains(nodeName) ?? false {
                            if let image = UIImage(named: "correct_answer.png") {
                                answerBox.texture = SKTexture(image: image)
                                // show level completed dialog
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    self.isLevelCompleted = true
                                }
                            }
                        }
                    } else {
                        var boxNode: SKSpriteNode?
                        if(!nodeName.contains("box")) {
                            boxNode = nodes.first(where: { $0.name == "\(nodeName)_box"})
                        } else {
                            boxNode = nodes.first(where: { $0.name == nodeName})
                        }
                        if let boxNode = boxNode {
                            
                            changeTextureNode(node: boxNode, wrongTexture: "wrong_answer.png", defaultTexture: "default_answer.png")
                            // change question node texture
                            if let questionNode = nodes.first(where: { $0.name == "first_question" }) {
                                changeTextureNode(node: questionNode, wrongTexture: "first_question_wrong.png", defaultTexture: "first_question.png")
                            }
                        }
                        
                        // disable touch
                        isTouchEnabled = false
                    }
                    
                }
            }
        }
        
    }
}
