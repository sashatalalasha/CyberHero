import SpriteKit

class PasswordGeneratorNode: SKSpriteNode {
    
    weak var delegate: PasswordGeneratorNodeDelegate?
    
    var title: SKSpriteNode!
    var loadingIndicator: SKSpriteNode!
    var loadingBlock: SKSpriteNode!
    var playAgainButton: SKSpriteNode!
    var regenerateButton: SKSpriteNode!
    var passwordNode: SKLabelNode!
    
    init(parentSize: CGSize) {
        let texture = SKTexture(imageNamed: "level_completed_box.png")
        super.init(texture: texture, color: .clear, size: texture.size())
        self.position = CGPoint(x: parentSize.width/2, y: parentSize.height/2)
        self.zPosition = 100
        createTitle(imageName: "level_completed_title")
        createLoadingComponents()
        startLoadingAnimation()
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createTitle(imageName: String) {
        title = SKSpriteNode(imageNamed: "\(imageName).png")
        title.position = CGPoint(x: 0, y: 100)  
        title.zPosition = 101
        title.name = imageName 
        addChild(title)
    }
    
    private func createLoadingComponents() {
                
        // create loading indicator
        loadingIndicator = SKSpriteNode(imageNamed: "loading_indicator.png")
        loadingIndicator.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        loadingIndicator.position = CGPoint(x: 0, y: -50)  
        loadingIndicator.zPosition = 101
        loadingIndicator.name = "loading_indicator"
        addChild(loadingIndicator)
        
        loadingBlock = SKSpriteNode(imageNamed: "loading_block.png")
        
        
    }
    
    func startLoadingAnimation() {
            var actions: [SKAction] = []
            
            // calculate how many blocks fit in a loading indicator
            let blockCount = Int(loadingIndicator.size.width / (loadingBlock.size.width + 20)) - 1
            
            for index in 0..<blockCount {
                let waitAction = SKAction.wait(forDuration: 0.5)
                let addAction = SKAction.run { [weak self] in
                    self?.addLoadingBlock(index: index)
                }
                actions += [waitAction, addAction]
                // if this is the last block, add fade out for the loading indicator
                if(index == blockCount - 1) {
                    let fadeOutAction = SKAction.fadeOut(withDuration: 1.0)
                    actions.append(fadeOutAction)
                }
                
            }
            // add fade out actions to every loading block
            for _ in 0..<loadingIndicator.children.count {
                let fadeOutBlockAction = SKAction.fadeOut(withDuration: 1.0)
                actions.append(fadeOutBlockAction)
            }
            
            // run fade out actions for both text and loading indicator simultaneously
            let fadeOutTextAction = SKAction.fadeOut(withDuration: 1.0)
            
            // after all actions are finished, generate a strong password
            loadingIndicator.run(SKAction.sequence(actions)) { [self] in
                
                
                // Change the texture of the text node
                let changeTextureAction = SKAction.run {
                    self.title.texture = SKTexture(imageNamed: "password_title.png")
                    self.title.size = self.title.texture!.size()
                }
                
                // run fade in action on the text node
                let fadeInAction = SKAction.fadeIn(withDuration: 0.5)
                
                let sequence = SKAction.sequence([fadeOutTextAction, changeTextureAction, fadeInAction])
                
                // run the sequence of actions on the text node
                title.run(sequence) {
                    // remove loading status
                    self.loadingIndicator.removeAllChildren()
                    // make loading block visible for future loadings
                    self.loadingBlock.alpha = 1.0
                    // generate strong password and show buttons
                    let password = self.generateStrongPassword()
                    self.addPasswordNode(password: password)
                    self.addPayAgainButton()
                    self.addRegenerateButton()
                }
            }
  
    }
    
    func regeneratePassword() {
  
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.5)
        let fadeInAction = SKAction.fadeIn(withDuration: 0.5)
        
               let changeTextureAction = SKAction.run {
            self.title.texture = SKTexture(imageNamed: "regenerate_text")
                   self.title.size = self.title.texture!.size()
        }
        
        passwordNode.run(fadeOutAction)
        regenerateButton.run(fadeOutAction)
        playAgainButton.run(fadeOutAction)
        title.run(changeTextureAction)
        loadingIndicator.run(fadeInAction) {
            
            self.startLoadingAnimation()
        }
  
    }
    
    func addLoadingBlock(index: Int) {
        let distance: CGFloat = 20  
        let blockCopy = loadingBlock.copy() as! SKSpriteNode
        let blockWidthWithDistance = blockCopy.size.width + distance
            
        blockCopy.position = CGPoint(x: -loadingIndicator.size.width / 2 + CGFloat(index + 1) * blockWidthWithDistance, y: 0)
        blockCopy.zPosition = 102
            
        loadingIndicator.addChild(blockCopy)       
    }
    
    private func addPasswordNode(password: String) {
        passwordNode = SKLabelNode(text: password)
        // position
        passwordNode.horizontalAlignmentMode = .center
        passwordNode.verticalAlignmentMode = .center
        passwordNode.position = CGPoint(x: 0, y: 0)
        // style
        passwordNode.fontSize = 50
        passwordNode.fontName = "Arial"
        passwordNode.fontColor = .black
        
        
        passwordNode.zPosition = 101
        passwordNode.name = "password"
        addChild(passwordNode)
    }
    
    func addPayAgainButton() {
        playAgainButton = SKSpriteNode(imageNamed: "play_again_button.png")
        playAgainButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        playAgainButton.position = CGPoint(x: 50 + playAgainButton.size.width/2, y: -100)  
        playAgainButton.zPosition = 101
        playAgainButton.alpha = 0.0
        playAgainButton.name = "play_again_button"
        addChild(playAgainButton)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.5)
        
        playAgainButton.run(fadeInAction)
    }
    
    func addRegenerateButton() {
        regenerateButton = SKSpriteNode(imageNamed: "regenerate_button.png")
        regenerateButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        regenerateButton.position = CGPoint(x: -50 - regenerateButton.size.width/2 , y: -100)  
        regenerateButton.zPosition = 101
        regenerateButton.alpha = 0.0
        regenerateButton.name = "regenerate_button"
        addChild(regenerateButton)
        
        let fadeInAction = SKAction.fadeIn(withDuration: 0.5)
        
        regenerateButton.run(fadeInAction)
    }
    
    func generateStrongPassword() -> String {
        let length = 8
        let charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var result = ""
        for _ in 0..<length {
            let randomIndex = Int.random(in: 0..<charset.count)
            let randomCharacter = charset[charset.index(charset.startIndex, offsetBy: randomIndex)]
            result.append(randomCharacter)
        }
        
        return result
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let node = self.atPoint(t.location(in :self))
     
            if (node.name == "regenerate_button") {
                self.regeneratePassword()
            } else if (node.name == "play_again_button") {
                delegate?.didTapPlayAgainButton()
            }
        }  
    }

}
