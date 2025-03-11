import Foundation

class SurpriseEggViewModel: ObservableObject {
    @Published var life: Int = 5
    @Published var isGamePaused: Bool = false
    @Published var isGameWin: Bool = false
    @Published var isGameOver: Bool = false
    @Published var activeBasketIndex: Int? = nil // Tracks the active basket

    private let lifeKey = "lifeKey"
    private let lastResetKey = "lastResetDateKey"
    
    init() {
        checkAndResetLives()
    }
    
    /// Handles basket spin logic
    func spinBasket(at index: Int) {
        activeBasketIndex = index // Set active basket
        
        let randomChance = Int.random(in: 1...3)
        if randomChance == 2 {
            winGame()
        } else {
            loseGame()
        }
        
        // Reset basket after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.activeBasketIndex = nil
        }
    }
    
    /// Handles win logic
    private func winGame() {
        isGameWin = true
        SettingsViewModel.shared.playSoundEffect(named: "winSound")
    }
    
    /// Handles lose logic
    private func loseGame() {
        if life > 0 {
            life -= 1
            saveLives()
        }
        isGameOver = true
        SettingsViewModel.shared.playSoundEffect(named: "loseSound")
    }
    
    /// Pauses the game
    func pauseGame() {
        isGamePaused = true
        SettingsViewModel.shared.playSoundEffect(named: "tapSound")
    }
    
    /// Resumes the game
    func resumeGame() {
        isGamePaused = false
        if life > 0 {
            isGameOver = false
        }
        SettingsViewModel.shared.playSoundEffect(named: "tapSound")
    }
    
    /// Checks if the player can play based on remaining lives
    func checkMayPlay() -> Bool {
        return life > 0
    }
    
    /// Checks if a new day has started and resets lives to 5 if necessary
    private func checkAndResetLives() {
        let lastResetDate = UserDefaults.standard.object(forKey: lastResetKey) as? Date ?? Date.distantPast
        let currentDate = Date()
        
        if !Calendar.current.isDate(lastResetDate, inSameDayAs: currentDate) {
            life = 5 // Reset lives
            saveLives()
            UserDefaults.standard.set(currentDate, forKey: lastResetKey) // Save reset date
        } else {
            loadLives()
        }
    }
    
    /// Saves the current number of lives to UserDefaults
    private func saveLives() {
        UserDefaults.standard.set(life, forKey: lifeKey)
    }
    
    /// Loads the last saved number of lives from UserDefaults
    private func loadLives() {
        let savedLives = UserDefaults.standard.integer(forKey: lifeKey)
        life = savedLives > 0 ? savedLives : 5
    }
}
