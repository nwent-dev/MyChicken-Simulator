import Foundation

class MoneyManager: ObservableObject {
    static let shared = MoneyManager()
    private let moneyKey = "moneyKey"
    
    @Published var money: Int = 20 {
        didSet {
            saveMoney()
        }
    }
    
    private init() {
        loadMoney()
    }
    
    func addMoney(howMuch: Int) {
        money += howMuch
    }
    
    func subtractMoney(howMuch: Int) {
        if money > howMuch {
            money -= howMuch
        }
    }
    
    private func saveMoney() {
        UserDefaults.standard.set(money, forKey: moneyKey)
    }
    
    private func loadMoney() {
        money = UserDefaults.standard.integer(forKey: moneyKey)
    }
}
