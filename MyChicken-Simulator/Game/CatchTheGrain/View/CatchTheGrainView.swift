import SwiftUI
import SpriteKit

/// ⚡ Класс сцены игры
class GameScene: SKScene, SKPhysicsContactDelegate {
    private var player: SKSpriteNode!
    private var scoreLabel: SKLabelNode!
    private var score = 0
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        backgroundColor = .white
        
        // 🔹 Добавляем игрока (курицу)
        player = SKSpriteNode(imageNamed: "chicken") // 👈 Используй свою картинку
        player.position = CGPoint(x: size.width / 2, y: size.height*0.1)
        player.setScale(0.35)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.isDynamic = false
        player.physicsBody?.categoryBitMask = 1
        player.physicsBody?.contactTestBitMask = 2
        player.physicsBody?.collisionBitMask = 0
        addChild(player)
        
        // 🔹 Добавляем очки
        scoreLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 50)
        scoreLabel.fontSize = 24
        scoreLabel.fontColor = .black
        scoreLabel.text = "Score: \(score)"
        addChild(scoreLabel)
        
        // 🔹 Запускаем таймер появления объектов
        let spawn = SKAction.run { [weak self] in
            self?.spawnFallingItem()
        }
        let wait = SKAction.wait(forDuration: 1.0)
        let sequence = SKAction.sequence([spawn, wait])
        run(SKAction.repeatForever(sequence))
    }
    
    /// 🏆 Добавляем падающий объект
    private func spawnFallingItem() {
        let item = SKSpriteNode(imageNamed: "dropItem") // 👈 Используй свою картинку
        let randomX = CGFloat.random(in: 50...(size.width - 50))
        item.position = CGPoint(x: randomX, y: size.height)
        item.setScale(0.5)
        
        item.physicsBody = SKPhysicsBody(rectangleOf: item.size)
        item.physicsBody?.categoryBitMask = 2
        item.physicsBody?.contactTestBitMask = 1
        item.physicsBody?.collisionBitMask = 0
        item.physicsBody?.affectedByGravity = true
        item.physicsBody?.velocity = CGVector(dx: 0, dy: -200)
        
        addChild(item)
    }
    
    /// 🎯 Обрабатываем коллизию (только падающие предметы исчезают)
    func didBegin(_ contact: SKPhysicsContact) {
        var fallingItem: SKSpriteNode?
        
        // Проверяем, кто из объектов является падающим предметом
        if contact.bodyA.categoryBitMask == 2 {
            fallingItem = contact.bodyA.node as? SKSpriteNode
        } else if contact.bodyB.categoryBitMask == 2 {
            fallingItem = contact.bodyB.node as? SKSpriteNode
        }
        
        // Удаляем падающий предмет и увеличиваем счёт
        if let fallingItem = fallingItem {
            fallingItem.removeFromParent()
            increaseScore()
        }
    }
    
    /// 🎯 Увеличиваем счет
    private func increaseScore() {
        score += 1
        scoreLabel.text = "Score: \(score)"
    }
    
    /// 🎮 Двигаем игрока (по горизонтали)
    func movePlayer(to position: CGPoint) {
        let newX = max(50, min(size.width - 50, position.x))
        player.position.x = newX
    }
}

/// 🎮 SwiftUI View для игры
struct Game2View: View {
    @State private var scene = GameScene(size: CGSize(width: 400, height: 800))
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            scene.movePlayer(to: value.location)
                        }
                )
        }
    }
}

/// ✅ Превью
#Preview {
    Game2View()
}
