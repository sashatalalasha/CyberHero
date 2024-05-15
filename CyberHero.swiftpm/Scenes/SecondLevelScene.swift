import SpriteKit

final class SecondLevelScene: SKScene{
    
    var isLevelCompleted: Bool = false {
        didSet {
            // show level completed dialog when a correct answer is selected
            if isLevelCompleted {
                self.addLevelCompletedDialog()
            }
        }
    }
    
    var chatBoxNode: SKSpriteNode?
    var currentStep: Int = 1
    
    var nodes:  [SKSpriteNode] = []
    
    override init(size: CGSize) {
        super.init(size: size)
        self.addBackground()
        self.createBackButton()
        createChatBox()
        createFirstBobMessage()
        createAnswers()
        
        scaleMode = .fill
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }  
    
    private func createChatBox(){
        chatBoxNode = SKSpriteNode(imageNamed: "chat_box.png")
        chatBoxNode!.position = CGPoint(x: frame.minX + 400, y: frame.midY)
        chatBoxNode!.name = "chat_box"
        addChild(chatBoxNode!)   
    }
    
    private func createFirstBobMessage() {
        if let chatBoxNode = chatBoxNode {
            // create from node and place it in the top left corner 
            let topLeftX = chatBoxNode.position.x - (chatBoxNode.size.width * chatBoxNode.anchorPoint.x)
            let topLeftY = chatBoxNode.position.y + (chatBoxNode.size.height * (1 - chatBoxNode.anchorPoint.y))
            let node = SKSpriteNode(imageNamed: "message_bob_1.png")
            node.name = "message_bob_1"
            node.position.y = chatBoxNode.position.y
            node.position = CGPoint(x: topLeftX + node.size.width/2 + 35, y: topLeftY - 230)
            
            addChild(node)
            
            nodes.append(node)
        }
    }
    
    private func createAnswers(){
        let images = (1...2).map { "message_\($0)" }
        
        // place answers in a column in random order
        for (index, imageName) in images.enumerated() {
            let node = SKSpriteNode(imageNamed:"\(imageName).png")
            let position = CGPoint(x: frame.midX + 300, y: frame.midY - 100*CGFloat(index))
            node.position = position
            node.name = imageName
            node.zPosition = 2
            
            addChild(node)
            nodes.append(node)
        }
    } 
    
    // change texture of a node for 2 seconds
    private func changeTextureNode(node: SKSpriteNode, newTexture: String, defaultTexture: String, completion: (() -> Void)? = nil) {
        // actions to be performed on a node
        let waitAction = SKAction.wait(forDuration: 0.5)
        
        // change texture of node when the answer was wrong
        let changeWrongTextureAction = SKAction.run {
            
            node.texture = SKTexture(imageNamed: newTexture)
        }
        
        // change texture to default 
        let changeDefaultTextureAction = SKAction.run {
            
            node.texture = SKTexture(imageNamed: defaultTexture)
        }
        // add actions to node
        node.run(SKAction.sequence([changeWrongTextureAction, waitAction, changeDefaultTextureAction])) {
            if let completion = completion {
                completion()
            }
        }
    }
    
    func addCorrentMessage(index: Int) {
        // get last Bob message
        if let bobMessage =  nodes.first(where: { $0.name == "message_bob_\(index)"}), let chatBoxNode = chatBoxNode{
            
            let node = SKSpriteNode(imageNamed: "message_lana_\(index).png")
            
            let xPosition = chatBoxNode.position.x + (chatBoxNode.size.width * (1 - chatBoxNode.anchorPoint.x))
            node.position = CGPoint(x: xPosition - node.size.width / 2 - 35, y: bobMessage.position.y - bobMessage.size.height / 2 - 70)
            node.name = "message_lana_\(index)"
            addChild(node)
            nodes.append(node)
            
            node.alpha = 0.0
            
            let fadeInAction = SKAction.fadeIn(withDuration: 0.5)
            node.run(fadeInAction) { [self] in
                
                currentStep+=1
                addSecondBobMessage()
                if(currentStep == 3) {
                    removeMessagesFromScreen()
                } else {
                    // change textures of response options
                    replaceMessageTexture(nodeName: "message_\(index)", newTexture: "message_\(index + 2)")
                    replaceMessageTexture(nodeName: "message_\(index + 1)", newTexture: "message_\(index + 3)")
                }
            }
        }
    }
    
    func removeMessagesFromScreen() {
        if let firstMessage =  nodes.first(where: { $0.name == "message_3"}), let secondMessage = nodes.first(where: { $0.name == "message_4"}) {
            let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
            firstMessage.run(fadeOutAction)
            secondMessage.run(fadeOutAction) {
                self.isLevelCompleted.toggle()
            }
        }
    }
    
    func addSecondBobMessage() {
        // get last lana message
        if let lanaMessage =  nodes.first(where: { $0.name == "message_lana_1"}), let chatBoxNode = chatBoxNode{
            // place second bob message
            let node = SKSpriteNode(imageNamed: "message_bob_2.png")
            let xPosition = chatBoxNode.position.x - (chatBoxNode.size.width * chatBoxNode.anchorPoint.x)
            node.position = CGPoint(x: xPosition + node.size.width / 2 + 35, y: lanaMessage.position.y - lanaMessage.size.height / 2 - 70)
            node.name = "message_bob_2"
            addChild(node)
            nodes.append(node)
            
            node.alpha = 0.0
            
            let fadeInAction = SKAction.fadeIn(withDuration: 0.5)
            node.run(fadeInAction)            
            
        }
    }
    
    
    func replaceMessageTexture(nodeName: String, newTexture: String) {
        if let node = nodes.first(where: { $0.name == nodeName}) {
            // get left corner of current node
            let originalXPostion = node.position.x - node.size.width / 2
            node.texture = SKTexture(imageNamed: "\(newTexture).png")
            node.name = newTexture
            node.size = node.texture!.size()
            // current x position esures that new texture stays aligned
            let currentXPosition = originalXPostion + node.size.width/2
            node.position = CGPoint(x: currentXPosition, y: node.position.y)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if touchedNode.name == "back_button" {
                let previousScene = LevelsScene(size: self.size, currentLevel: 2)
                view?.presentScene(previousScene, transition: .crossFade(withDuration: 0.5))
            }
            if  touchedNode.name == "next_button" {
                let levelsScene = LevelsScene(size: self.size, currentLevel: 3)
                view?.presentScene(levelsScene, transition: .crossFade(withDuration: 0.5))
            }
            
            if(currentStep == 1 ) {
                if(touchedNode.name == "message_1") {
                    if let messageNode = nodes.first(where: { $0.name == touchedNode.name}) {
                        changeTextureNode(node: messageNode, newTexture: "message_1_green.png", defaultTexture: "message_1.png") {
                            self.addCorrentMessage(index: 1)
                        }
                        
                    }
                } 
                // wrong message selected
                if(touchedNode.name == "message_2") {
                    
                    if let messageNode = nodes.first(where: { $0.name == touchedNode.name}) {
                        changeTextureNode(node: messageNode, newTexture: "message_2_red.png", defaultTexture: "message_2.png")
                        
                    }
                }
            } else if (currentStep == 2){
                if(touchedNode.name == "message_4") {
                    if let messageNode = nodes.first(where: { $0.name == touchedNode.name}) {
                        changeTextureNode(node: messageNode, newTexture: "message_4_green.png", defaultTexture: "message_4.png") {
                            self.addCorrentMessage(index: 2)
                        }
                        
                    }
                } 
                // wrong message selected
                if(touchedNode.name == "message_3") {
                    
                    if let messageNode = nodes.first(where: { $0.name == touchedNode.name}) {
                        changeTextureNode(node: messageNode, newTexture: "message_3_red.png", defaultTexture: "message_3.png")
                    }
                }  
            }
        }
    }
}
