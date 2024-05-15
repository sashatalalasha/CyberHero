import SpriteKit

final class LevelsScene: SKScene, PasswordGeneratorNodeDelegate {
    var currentLevel: Int
    
    var nodes: [SKSpriteNode] = []
    
    init(size: CGSize, currentLevel: Int) {
        self.currentLevel = currentLevel
        super.init(size: size)
        self.addBackground()
        addHorizontalSprites()
        
        scaleMode = .fill
        
        if(self.currentLevel == 4) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let passwordGeneratorNode =  self.addPasswordGeneratorDialog()
                passwordGeneratorNode.delegate = self
                self.addChild(passwordGeneratorNode)
                
            }
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapPlayAgainButton() {
        // navigate to introduction scene to restart game
        let introductionScene = IntroductionScene(size: self.size)
        view?.presentScene(introductionScene, transition: .crossFade(withDuration: 0.5))
    }
    
    func addHorizontalSprites() {
        let passwordNode = createPasswordNode()
        let emailNode = createEmailNode()
        let personalInfoNode = createPersonalInfoNode()
        
        let totalWidth = passwordNode.size.width + personalInfoNode.size.width + emailNode.size.width + 200
        
        var startX = (size.width - totalWidth) / 2
        let yPosition =  -max(passwordNode.size.height, emailNode.size.height)/2 - 50
        positionLevel(node: passwordNode, xPosition: startX)
        addLevelLabelNode(parentNode: passwordNode, yPosition: yPosition, levelIndex: 1)
        
        startX+=passwordNode.size.width + 100
        positionLevel(node: personalInfoNode, xPosition: startX)
        addLevelLabelNode(parentNode: personalInfoNode, yPosition: yPosition, levelIndex: 2)
        
        startX+=personalInfoNode.size.width + 100
        positionLevel(node: emailNode, xPosition: startX)
        addLevelLabelNode(parentNode: emailNode, yPosition: yPosition, levelIndex: 3)
    }
    
    private func positionLevel(node: SKSpriteNode, xPosition: CGFloat) {
        node.position = CGPoint(x: xPosition , y: size.height / 2)
        
        node.anchorPoint = CGPoint(x: 0, y: 0.5)
        
        addChild(node)
        nodes.append(node)
        
    }
    
    private func addLevelLabelNode(parentNode: SKSpriteNode, yPosition: CGFloat, levelIndex: Int) {
        let textNode = SKSpriteNode(imageNamed: "level_\(levelIndex)_title.png")
        
        // x value to place the text node in the center
        let x =  parentNode.size.width / 2
        
        textNode.position = CGPoint(x: x, y: yPosition)
        
        textNode.zPosition = 100
        
        parentNode.addChild(textNode)
    }
    
    private func createPasswordNode() -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: (currentLevel == 1) ? "password_not_passed.png" : "password_passed.png")
        node.name = "password_level"
        // opacity is 1 since this is the first level
        node.alpha = 1
        
        return node
        
    }
    
    private func createEmailNode() -> SKSpriteNode{
        let node = SKSpriteNode(imageNamed: (currentLevel < 4) ? "email_not_passed.png" : "email_passed.png")
        node.name = "email_level"
        // if level is not opened, opacity is 0.5
        node.alpha = currentLevel > 2 ? 1 : 0.5
        
        
        return node
    }
    
    private func createPersonalInfoNode() -> SKSpriteNode{
        let node = SKSpriteNode(imageNamed: (currentLevel < 3) ? "personal_info_not_passed.png" : "personal_info_passed.png")
        node.name = "personal_info_level"
        // if level is not opened, opacity is 0.5
        node.alpha = currentLevel > 1 ? 1 : 0.5
        
        return node
    }
    
    func createBounceAction() -> SKAction {
        let scaleUp = SKAction.scale(to: 1.2, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.2)
        return SKAction.sequence([scaleUp, scaleDown])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let node = self.atPoint(t.location(in :self))
            
            if (node.name == "password_level" && currentLevel == 1)  {
                // bounce a node and navigate to selected level
                node.bounce { [weak self] in
                    // if self is not null, update presented level to selected level
                    guard let self = self else { return }
                    
                    let nextScene = FirstLevelIntroductionScene(size: self.size)
                    view?.presentScene(nextScene, transition: .crossFade(withDuration: 0.5))
                }
            }
            if (node.name == "personal_info_level" && currentLevel == 2) {
                // bounce a node and navigate to selected level
                node.bounce { [weak self] in
                    // if self is not null, update presented level to selected level
                    guard let self = self else { return }
                    
                    let nextScene = SecondLevelIntroductionScene(size: self.size)
                    view?.presentScene(nextScene, transition: .crossFade(withDuration: 0.5))
                }
            }
            if (node.name == "email_level" && currentLevel == 3) {
                // bounce a node and navigate to selected level
                node.bounce { [weak self] in
                    // if self is not null, update presented level to selected level
                    guard let self = self else { return }
                    
                    let nextScene = ThirdLevelIntroductionScene(size: self.size)
                    view?.presentScene(nextScene, transition: .crossFade(withDuration: 0.5))
                }
            }
            
        }
        
    }
}
