import SpriteKit

final class SecondLevelIntroductionScene: SKScene {
    
    var nodes: [SKSpriteNode] = []
    
    override init(size: CGSize) {
        super.init(size: size)
        self.addBackground()
        self.createBackButton()
        let bubbleNodes = self.createBubbleNode(firstTexture: "2nd_level_introduction_1")
        nodes+=bubbleNodes
        let lanaNode = self.createLanaNode()
        nodes.append(lanaNode)
        
        scaleMode = .fill
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func goToNextText() {
        for node in nodes {
            if node.name == "2nd_level_introduction_1" {
                // replace old introduction with next
                node.texture = SKTexture(imageNamed: "2nd_level_introduction_2.png")
                node.name = "2nd_level_introduction_2"
                node.size = node.texture!.size() 
            }
            else if node.name == "2nd_level_introduction_2" {
                // replace old introduction with next
                node.texture = SKTexture(imageNamed: "2nd_level_introduction_3.png")
                node.name = "2nd_level_introduction_3"
                node.size = node.texture!.size() 
                // add start button with the last introduction text
                changeNextButtonToStartButtonNode()
            }
        }
    }
    
    private func changeNextButtonToStartButtonNode() {
        if let node = nodes.first(where: { $0.name == "next_button"}) {
            node.texture = SKTexture(imageNamed: "start_button")
            node.size = node.texture!.size()
            node.name = "start_button"
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = self.atPoint(location)
            
            if let nodeName = touchedNode.name {
                switch nodeName {
                case "back_button":
                    let previousScene = LevelsScene(size: self.size, currentLevel: 2)
                    view?.presentScene(previousScene, transition: .crossFade(withDuration: 0.5))
                case "start_button":
                    let nextScene = SecondLevelScene(size: self.size)
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
