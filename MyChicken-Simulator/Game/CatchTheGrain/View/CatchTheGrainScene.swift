import SwiftUI
import SpriteKit

/// ⚡ Класс сцены игры
class CatchTheGrainScene: SKScene, SKPhysicsContactDelegate {
    private var player: SKSpriteNode!
    private var background: SKSpriteNode!
    private var gameViewModel: CatchTheGrainViewModel? // Ссылка на ViewModel
    private var spawnAction: SKAction? // Действие появления предметов
    
    /// 🎮 Устанавливаем ViewModel (вызываем при создании сцены)
    func setViewModel(_ viewModel: CatchTheGrainViewModel) {
        self.gameViewModel = viewModel
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        // 💡 Устанавливаем прозрачный фон
        view.backgroundColor = .clear
        
        // 🔹 Добавляем фон (картинку `bg2.png`)
        background = SKSpriteNode(imageNamed: "bg2.png")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = size // Растягиваем на весь экран
        background.zPosition = -1 // Фон должен быть сзади всех объектов
        addChild(background)

        // 🔹 Добавляем игрока (курицу)
        player = SKSpriteNode(imageNamed: "chicken")
        player.position = CGPoint(x: size.width / 2, y: size.height * 0.1)
        player.setScale(0.33)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.isDynamic = false
        player.physicsBody?.categoryBitMask = 1
        player.physicsBody?.contactTestBitMask = 2
        player.physicsBody?.collisionBitMask = 0
        addChild(player)
        
        // 🔹 Запускаем таймер появления объектов
        spawnAction = SKAction.sequence([
            SKAction.run { [weak self] in self?.spawnFallingItem() },
            SKAction.wait(forDuration: 1.0)
        ])
        run(SKAction.repeatForever(spawnAction!), withKey: "spawnItems")
    }
    
    /// 🏆 Добавляем падающий объект
    private func spawnFallingItem() {
        guard !(gameViewModel?.isGamePaused ?? false) else { return } // Остановить спавн во время паузы
        
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
    
    /// 🎯 Обрабатываем коллизию (только падающие предметы исчезают)
    func didBegin(_ contact: SKPhysicsContact) {
        guard !(gameViewModel?.isGamePaused ?? false) else { return } // Останавливаем обработку
        
        var fallingItem: SKSpriteNode?
        
        if contact.bodyA.categoryBitMask == 2 {
            fallingItem = contact.bodyA.node as? SKSpriteNode
        } else if contact.bodyB.categoryBitMask == 2 {
            fallingItem = contact.bodyB.node as? SKSpriteNode
        }
        
        if let fallingItem = fallingItem {
            fallingItem.removeFromParent()
            increaseScore()
        }
    }
    
    /// 🎯 Увеличиваем счет и передаём в `CatchTheGrainViewModel`
    private func increaseScore() {
        gameViewModel?.increaseScore() // Теперь обновляем ViewModel
    }
    
    /// 🎮 Двигаем игрока (по горизонтали), но не во время паузы
    func movePlayer(to position: CGPoint) {
        guard !(gameViewModel?.isGamePaused ?? false) else { return }
        
        let newX = max(50, min(size.width - 50, position.x))
        player.position.x = newX
    }
    
    /// ⏸ Пауза игры (останавливает спавн и замораживает объекты)
    func pauseGame() {
        isPaused = true
        removeAction(forKey: "spawnItems") // Останавливаем спавн предметов
        
        // Останавливаем все падающие предметы
        children.forEach { node in
            node.isPaused = true
        }
    }
    
    /// ▶️ Возобновление игры
    func resumeGame() {
        isPaused = false
        run(SKAction.repeatForever(spawnAction!), withKey: "spawnItems") // Возобновляем спавн предметов
        
        // Размораживаем все падающие предметы
        children.forEach { node in
            node.isPaused = false
        }
    }
}
