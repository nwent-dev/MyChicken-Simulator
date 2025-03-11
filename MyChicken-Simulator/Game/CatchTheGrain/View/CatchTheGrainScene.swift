import SwiftUI
import SpriteKit

class CatchTheGrainScene: SKScene, SKPhysicsContactDelegate {
    private var player: SKSpriteNode!
    private var background: SKSpriteNode!
    private var gameViewModel: CatchTheGrainViewModel?
    private var spawnAction: SKAction?
    
    func setViewModel(_ viewModel: CatchTheGrainViewModel) {
        self.gameViewModel = viewModel
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        view.backgroundColor = .clear
        
        background = SKSpriteNode(imageNamed: "bg2.png")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = size
        background.zPosition = -1
        addChild(background)

        player = SKSpriteNode(imageNamed: "chicken")
        player.position = CGPoint(x: size.width / 2, y: size.height * 0.1)
        player.setScale(0.33)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.isDynamic = false
        player.physicsBody?.categoryBitMask = 1
        player.physicsBody?.contactTestBitMask = 2
        player.physicsBody?.collisionBitMask = 0
        addChild(player)
        
        spawnAction = SKAction.sequence([
            SKAction.run { [weak self] in self?.spawnFallingItem() },
            SKAction.wait(forDuration: 1.0)
        ])
        run(SKAction.repeatForever(spawnAction!), withKey: "spawnItems")
    }
    
    private func spawnFallingItem() {
        guard !(gameViewModel?.isGamePaused ?? false) else { return }
        
        let item = SKSpriteNode(imageNamed: "dropItem")
        let randomX = CGFloat.random(in: 50...(size.width - 50))
        item.position = CGPoint(x: randomX, y: size.height)
        item.setScale(0.6)
        
        item.physicsBody = SKPhysicsBody(rectangleOf: item.size)
        item.physicsBody?.categoryBitMask = 2
        item.physicsBody?.contactTestBitMask = 1
        item.physicsBody?.collisionBitMask = 0
        item.physicsBody?.affectedByGravity = true
        item.physicsBody?.velocity = CGVector(dx: 0, dy: -200)
        
        addChild(item)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard !(gameViewModel?.isGamePaused ?? false) else { return }
        
        var fallingItem: SKSpriteNode?
        
        if contact.bodyA.categoryBitMask == 2 {
            fallingItem = contact.bodyA.node as? SKSpriteNode
        } else if contact.bodyB.categoryBitMask == 2 {
            fallingItem = contact.bodyB.node as? SKSpriteNode
        }
        
        if let fallingItem = fallingItem {
            fallingItem.removeFromParent()
            increaseScore()
            SettingsViewModel.shared.playSoundEffect(named: "catchSound")
        }
    }
    
    private func increaseScore() {
        gameViewModel?.increaseScore()
    }
    
    func movePlayer(to position: CGPoint) {
        guard !(gameViewModel?.isGamePaused ?? false) else { return }
        
        let newX = max(50, min(size.width - 50, position.x))
        player.position.x = newX
    }
    
    func pauseGame() {
        isPaused = true
        removeAction(forKey: "spawnItems")
        
        children.forEach { node in
            node.isPaused = true
        }
    }
    
    func resumeGame() {
        isPaused = false
        run(SKAction.repeatForever(spawnAction!), withKey: "spawnItems") 
        
        children.forEach { node in
            node.isPaused = false
        }
    }
}
