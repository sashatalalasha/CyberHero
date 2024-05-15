import SpriteKit

extension SKNode {
    func bounce(completion: @escaping () -> Void) {
        // scale up the node to make it appear as if bouncing
        let scaleUp = SKAction.scale(to: 1.2, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.2)
        let bounceAction = SKAction.sequence([scaleUp, scaleDown])
        
        // execute code in main thread and avoid cycles
        DispatchQueue.main.async { [weak self] in
            self?.run(bounceAction, completion: {
                completion()
            })
        }
        
    }
}


