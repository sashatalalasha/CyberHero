import SpriteKit

final class ThirdLevelScene: SKScene{
    
    var isLevelCompleted: Bool = false {
        didSet {
            // show level completed dialog when a correct answer is selected
            if isLevelCompleted {
                self.addLevelCompletedDialog()
            }
        }
    }
    private var selectedNode: SKNode?
    
    var imageNames: [String] = ["text_1", "challenge_4", "text_2","text_3"
                                , "challenge_5"]
    var correctAnswer: String  =  "first_question_answer_1_1"
    var nodes:  [EmailNode] = []
    
    override init(size: CGSize) {
        super.init(size: size)
        self.addBackground()
        self.createBackButton()
        let emailBox = createEmailBox(size: size)
        createEmailHeading(emailBox: emailBox)
        createEmailGreeting(emailBox: emailBox)
        createEmailBody(emailBox: emailBox)
        createEmailSignature(emailBox: emailBox)
        createAnswers()
        
        scaleMode = .fill
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }  
    
    
    private func createLevelCompletedBanner() {
        let position = CGPoint(x: frame.midX, y: frame.midY)
        let node = SKSpriteNode(imageNamed: "correct_answer.png")
        node.position = position
        node.zPosition = 100
        node.name = "correct_answer"
        
        addChild(node)
        nodes.append(EmailNode(isDraggable: false, node: node, startPosition: node.position))
    }
    
    
    private func createEmailBox(size: CGSize) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: "email_box.png")
        node.position = CGPoint(x: frame.minX + 400, y: frame.midY)
        node.name = "email_box"
        addChild(node)
        return node
        
    }
    
    private func createEmailHeading(emailBox: SKSpriteNode) { 
        // create from node and place it in the top left corner 
        let topLeftX = emailBox.position.x - (emailBox.size.width * emailBox.anchorPoint.x)
        let topLeftY = emailBox.position.y + (emailBox.size.height * (1 - emailBox.anchorPoint.y))
        let fromNode = SKSpriteNode(imageNamed: "challenge_1.png")
        fromNode.name = "challenge_1"
        fromNode.position.y = emailBox.position.y
        fromNode.position = CGPoint(x: topLeftX + fromNode.size.width/2 + 35, y: topLeftY - 100)
        
        addChild(fromNode)
        
        nodes.append(EmailNode(isDraggable: false, node: fromNode, startPosition: fromNode.position))
        
        // create a subject node and place it in the top left corner 
        let subjectNode = SKSpriteNode(imageNamed: "challenge_2.png")
        subjectNode.name = "challenge_2"
        subjectNode.position.y = emailBox.position.y
        subjectNode.position = CGPoint(x: topLeftX + subjectNode.size.width/2 + 35, y: topLeftY - 160)
        
        addChild(subjectNode)
        
        nodes.append(EmailNode(isDraggable: false, node: subjectNode, startPosition: fromNode.position))
        
        
    }
    
    private func createEmailGreeting(emailBox: SKSpriteNode) {
        let topLeftX = emailBox.position.x - (emailBox.size.width * emailBox.anchorPoint.x)
        
        let greetingNode = SKSpriteNode(imageNamed: "challenge_3.png")
        greetingNode.name = "challenge_3"
        
        greetingNode.position = CGPoint(x: topLeftX + greetingNode.size.width/2 + 35, y: emailBox.size.height/2 + 200)
        
        addChild(greetingNode)
        
        nodes.append(EmailNode(isDraggable: false, node: greetingNode, startPosition: greetingNode.position))
    }
    
    private func createEmailSignature(emailBox: SKSpriteNode) {
        let bottomLeftX = emailBox.position.x - (emailBox.size.width * emailBox.anchorPoint.x)
        let bottomLeftY = emailBox.position.y - (emailBox.size.height * emailBox.anchorPoint.y)
        
        
        let signatureNode = SKSpriteNode(imageNamed: "challenge_6.png")
        signatureNode.name = "challenge_6"
        signatureNode.position = CGPoint(x: bottomLeftX + signatureNode.size.width/2 + 35, y: bottomLeftY + 200)
        
        addChild(signatureNode)
        
        nodes.append(EmailNode(isDraggable: false, node: signatureNode, startPosition: emailBox.position))
    }
    
    private func createTextNode(name: String) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: "\(name).png")
        node.name = name
        return node
        
    } 
    
    private func createEmailBody( emailBox: SKSpriteNode) {
        let topLeftX = emailBox.position.x - (emailBox.size.width * emailBox.anchorPoint.x)
        
        var totalWidth: CGFloat = topLeftX + 35
        var totalHeight: CGFloat = emailBox.size.height / 2 + 100 
        
        for name in imageNames {
            let sentenceNode = createTextNode(name: name)
            sentenceNode.name = name
            
            sentenceNode.position.x = totalWidth + sentenceNode.size.width / 2
            sentenceNode.position.y = totalHeight 
            
            addChild(sentenceNode)
            nodes.append(EmailNode(isDraggable: false, node: sentenceNode, startPosition: sentenceNode.position))
            
            totalWidth += sentenceNode.size.width + 20
            
            if totalWidth > emailBox.size.width - 35 {
                // move to the next line if the maxWidth is exceeded
                totalWidth = topLeftX + 35
                // adjust the vertical position
                totalHeight -= 60  
            }
        }
    }
    
    private func createAnswers(){
        let images = (1...6).map { "challenge_\($0)_answer" }.shuffled()
        
        // place answers in a column in random order
        for (index, imageName) in images.enumerated() {
            let node = SKSpriteNode(imageNamed:"\(imageName).png")
            let position = CGPoint(x: frame.midX + 300, y: frame.midY + 50*CGFloat(index + 1))
            node.position = position
            node.name = imageName
            node.zPosition = 2
            
            addChild(node)
            nodes.append(EmailNode(isDraggable: true, node: node, startPosition: position))
        }
        
    } 
    // get a node with the highest area of intersection as an answer can intersect with multiple sentences
    func getIntersectingNode() -> EmailNode? {
        var maxIntersectionArea: CGFloat = 0.0
        var nodeWithMaxIntersection: EmailNode?
        
        for emailNode in nodes {
            if let movedNode = self.selectedNode, emailNode.node !== movedNode && emailNode.node.intersects(movedNode) {
                let intersectionFrame = emailNode.node.calculateAccumulatedFrame().intersection(movedNode.calculateAccumulatedFrame())
                let intersectionArea = intersectionFrame.width * intersectionFrame.height
                
                if intersectionArea > maxIntersectionArea {
                    maxIntersectionArea = intersectionArea
                    nodeWithMaxIntersection = emailNode
                }
            }
        }
        
        return nodeWithMaxIntersection
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if let movedNode = nodes.first(where: { $0.node.name == touchedNode.name }){
                if movedNode.isDraggable {
                    self.selectedNode = touchedNode
                }
            } 
            if touchedNode.name == "back_button" {
                let previousScene = LevelsScene(size: self.size, currentLevel: 3)
                view?.presentScene(previousScene, transition: .crossFade(withDuration: 0.5))
            }
            if  touchedNode.name == "next_button" {
                let levelsScene = LevelsScene(size: self.size, currentLevel: 4)
                view?.presentScene(levelsScene, transition: .crossFade(withDuration: 0.5))
            }
            
            
            
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let selectedNode = self.selectedNode else {
            return
        }
        
        if let movedNode = nodes.first(where: { $0.node.name == selectedNode.name }) {
            // move node only if its draggable (answer node)
            if movedNode.isDraggable {
                let location = touch.location(in: self)
                selectedNode.position = location
            }
        } else {
            let location = touch.location(in: self)
            selectedNode.position = location
        }
    }
    
    private func moveNodeToStartPosition(nodeName: String) {
        if let movedNode = nodes.first(where: { $0.node.name == nodeName }) {
            
            let position = movedNode.startPosition
            let action = SKAction.move(to: position, duration: 0.5)
            self.selectedNode?.run(action)
            self.selectedNode = nil
        }
    }
    
    private func checkChallengesPassed() {
        if !nodes.contains(where: { $0.node.name?.contains("answer") == true }) {
            // all challenges passed, set level as completed
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isLevelCompleted = true
            }
        } 
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let selectedNode = self.selectedNode {
            selectedNode.position = touch.location(in: self)
        }
        
        if let movedNode = self.selectedNode, let movedNodeName = movedNode.name{
            
            if let intersectedNode = getIntersectingNode()
            {
                // answer intersected with a corresponding sentence
                if let intersectedNodeName = intersectedNode.node.name, movedNodeName.contains(intersectedNodeName) {
                    markCorrectAnswer(node: intersectedNode.node)
                    movedNode.removeFromParent()
                    // remove answer from nodes 
                    nodes = nodes.filter { $0.node.name != movedNodeName }
                    self.selectedNode = nil
                    checkChallengesPassed()
                    
                } else {
                    moveNodeToStartPosition(nodeName: movedNodeName)
                }
            } else {
                moveNodeToStartPosition(nodeName: movedNodeName)        
            }
        }
    }
    
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {   
        self.selectedNode = nil       
    }
    
    func markCorrectAnswer(node: SKSpriteNode) {
        let check = SKSpriteNode(imageNamed: "check.png")
        let bottomRightX = node.position.x + (node.size.width * (1 - node.anchorPoint.x))
        let bottomRightY = node.position.y - (node.size.height * node.anchorPoint.y)
        // position the node in the lower right corner of the text node
        check.position = CGPoint(x: bottomRightX, y: bottomRightY)
        
        // place check on top of text node
        check.zPosition = 2
        
        addChild(check)
        nodes.append(EmailNode(isDraggable: false, node: check, startPosition: check.position))
    }
    
}
