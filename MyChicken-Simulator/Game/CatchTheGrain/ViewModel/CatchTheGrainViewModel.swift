import Foundation

class CatchTheGrainViewModel: ObservableObject {
    @Published var score: Int = 0 // current score
    @Published var levelTask: Int = 30 // Количество очков для победы
    @Published var isGamePaused: Bool = false // Флаг паузы
    @Published var isGameOver: Bool = false // Флаг окончания игры
    @Published var isGameWon: Bool = false // Флаг победы
    @Published var timeMinutes: String = "00" // Минуты (всегда 2 знака)
    @Published var timeSeconds: String = "00" // Секунды (всегда 2 знака)
    
    private var gameTimer: Timer? // Таймер игры
    private let gameDuration: TimeInterval = 60 // 60 секунд на уровень
    private var remainingTime: TimeInterval = 60 // Оставшееся время
    private var endTime: Date? // Время окончания игры
    
    init() {
        restartGame()
    }
    
    func howMuchEarned() -> Int {
        return score / (levelTask / 10)
    }
    
    // inrease score and check win
    func increaseScore() {
        guard !isGamePaused, !isGameOver else { return }
        
        score += 1
        
        if score >= levelTask {
            winGame()
        }
    }
    
    // start the game timer
    private func startGameTimer() {
        gameTimer?.invalidate()
        endTime = Date().addingTimeInterval(remainingTime)
        
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateRemainingTime()
        }
    }
    
    // Pause game
    func pauseGame() {
        isGamePaused = true
        gameTimer?.invalidate()
        
        if let endTime = endTime {
            remainingTime = max(0, endTime.timeIntervalSinceNow) // Save remaining time
        }
    }
    
    // resume game
    func resumeGame() {
        guard isGamePaused, !isGameOver else { return }
        
        isGamePaused = false
        startGameTimer() // Start timer with remaining time
    }
    
    // restart game
    func restartGame() {
        score = 0
        isGamePaused = false
        isGameOver = false
        isGameWon = false
        remainingTime = gameDuration // restart timer
        startGameTimer()
    }
    
    // exit game out
    func exitGame() {
        isGamePaused = true
        gameTimer?.invalidate()
    }
    
    // win
    private func winGame() {
        isGameWon = true
        isGameOver = true
        isGamePaused = true
        gameTimer?.invalidate()
        
        let earned = score / (levelTask / 10)
        MoneyManager.shared.addMoney(howMuch: earned) // 💰 Добавляем деньги сразу при победе
    }
    
    // lose
    private func loseGame() {
        guard !isGameWon else { return }
        isGameOver = true
        isGamePaused = true
        gameTimer?.invalidate()
    }
    
    // update remaining time
    private func updateRemainingTime() {
        guard let endTime = endTime else { return }
        
        remainingTime = max(0, endTime.timeIntervalSinceNow) // update remaining time
        
        let minutes = Int(remainingTime) / 60
        let seconds = Int(remainingTime) % 60
        
        timeMinutes = String(format: "%02d", minutes)
        timeSeconds = String(format: "%02d", seconds)
        
        if remainingTime <= 0 {
            loseGame()
        }
    }
    
    deinit {
        exitGame()
    }
}
