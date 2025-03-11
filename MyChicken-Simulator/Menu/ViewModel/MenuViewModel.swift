import Foundation
import UIKit

class MenuViewModel: ObservableObject {
    @Published var foodProgress: CGFloat = 1 // min 0.26 max 1
    @Published var moodProgress: CGFloat = 1 // min 0.26 max 1
    @Published var tirednessProgress: CGFloat = 0.26 // min 0.26 max 1
    
    @Published var isSleeping: Bool = false
    @Published var sleepMinutes: String = "00" // ✅ Двухзначный формат
    @Published var sleepSeconds: String = "00" // ✅ Двухзначный формат

    @Published var isFeedMenuOpen: Bool = false
    @Published var selectedFood: Food?
    @Published var food: [Food] = [
        Food(image: "food1", ccal: 0.1, price: 5),
        Food(image: "food2", ccal: 0.2, price: 7),
        Food(image: "food3", ccal: 0.4, price: 10),
        Food(image: "food4", ccal: 0.8, price: 15),
    ]
    
    @Published var isDreamMenuOpen: Bool = false
    @Published var selectedTime: String?
    @Published var times: [String] = ["5min", "10min", "15min", "30min", "60min"]

    @Published var isCareMenuOpened: Bool = false
    @Published var cares: [String] = ["petTheChickenBtn","playWithTheChickenBtn"]
    @Published var selectedCare: String?

    private var sleepEndTime: Date?
    private var sleepTimer: Timer?
    private var foodTimer: Timer?

    init() {
        loadData()
        startFoodDecay()
        restoreSleepState()
        setupAppLifecycleObservers()

        if sleepTimer == nil {
            isSleeping = false
            UserDefaults.standard.set(false, forKey: "isSleeping") // Сохраняем в память
        }
    }


    private func startFoodDecay() {
        foodTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if self.foodProgress > 0.26 {
                    self.foodProgress -= 0.025
                    self.saveData()
                }
            }
        }
    }
    
    func feedChicken() {
        if let food = selectedFood {
            self.foodProgress = min(self.foodProgress + food.ccal, 1)
            MoneyManager.shared.subtractMoney(howMuch: food.price)
            isFeedMenuOpen = false
            saveData()
        } else {
            print("Food not chosen")
        }
    }
    
    func careForChicken() {
        guard let care = selectedCare else {
            print("Care action not selected")
            return
        }
        
        switch care {
        case "petTheChickenBtn":
            self.moodProgress = min(self.moodProgress + 0.1, 1)
        case "playWithTheChickenBtn":
            self.moodProgress = min(self.moodProgress + 0.2, 1)
        default:
            break
        }
        
        isCareMenuOpened = false
        saveData()
    }
    
    func sleepChicken() {
        guard let selectedTime = selectedTime else {
            print("Sleep time not selected")
            return
        }
        
        let sleepDuration: TimeInterval
        
        switch selectedTime {
        case "5min": sleepDuration = 5 * 60
        case "10min": sleepDuration = 10 * 60
        case "15min": sleepDuration = 15 * 60
        case "30min": sleepDuration = 30 * 60
        case "60min": sleepDuration = 60 * 60
        default:
            print("Invalid sleep time selected")
            return
        }
        
        sleepEndTime = Date().addingTimeInterval(sleepDuration)
        isSleeping = true

        UserDefaults.standard.set(sleepEndTime, forKey: "sleepEndTime")

        startSleepTimer()
    }

    private func startSleepTimer() {
        sleepTimer?.invalidate()
        sleepTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self, let sleepEndTime = self.sleepEndTime else { return }

            let remainingTime = max(0, sleepEndTime.timeIntervalSinceNow)
            self.updateSleepTime(remainingTime)

            if remainingTime <= 0 {
                self.stopSleepTimer()
            }
            
            if Int(remainingTime) % 15 == 0 {
                self.tirednessProgress = max(self.tirednessProgress - 0.003333333333, 0)
                self.saveData()
            }
        }
    }

    private func restoreSleepState() {
        if let savedEndTime = UserDefaults.standard.object(forKey: "sleepEndTime") as? Date {
            let remainingTime = max(0, savedEndTime.timeIntervalSinceNow)
            
            if remainingTime > 0 {
                sleepEndTime = savedEndTime
                isSleeping = true
                startSleepTimer()
                
                // ✅ **Вычисляем сколько усталости нужно отнять**
                let elapsedTime = sleepEndTime!.timeIntervalSince(savedEndTime)
                let tirednessToRemove = elapsedTime / 15 * 0.003333333333
                self.tirednessProgress = max(self.tirednessProgress - tirednessToRemove, 0)
                
            } else {
                stopSleepTimer()
            }
        }
    }

    private func setupAppLifecycleObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterBackground), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    @objc private func appWillEnterBackground() {
        saveData()
        if let sleepEndTime = sleepEndTime {
            UserDefaults.standard.set(sleepEndTime, forKey: "sleepEndTime")
        }
    }

    @objc private func appDidBecomeActive() {
        restoreSleepState()
    }

    private func updateSleepTime(_ timeInterval: TimeInterval) {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        sleepMinutes = String(format: "%02d", minutes) // ✅ Формат "00"
        sleepSeconds = String(format: "%02d", seconds) // ✅ Формат "00"
    }
    
    func stopSleepTimer() {
        sleepTimer?.invalidate()
        sleepEndTime = nil
        isSleeping = false // ✅ Явно сбрасываем перед сохранением
        sleepMinutes = "00"
        sleepSeconds = "00"
        UserDefaults.standard.set(false, forKey: "isSleeping") // ✅ Сохраняем сброс сна
        UserDefaults.standard.removeObject(forKey: "sleepEndTime")
    }

    
    func playGame() {
        tirednessProgress += 0.16
        moodProgress -= 0.16
    }
    
    func mayPlayGame() -> Bool {
        if foodProgress > 0.26 && moodProgress > 0.26 && isSleeping != true && tirednessProgress < 1 {
            return true
        } else {
            return false
        }
    }
    
    deinit {
        foodTimer?.invalidate()
        sleepTimer?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
    
    private func saveData() {
        let data: [String: Any] = [
            "foodProgress": foodProgress,
            "moodProgress": moodProgress,
            "tirednessProgress": tirednessProgress,
            "isSleeping": isSleeping
        ]
        UserDefaults.standard.set(data, forKey: "menuData")
    }

    private func loadData() {
        if let savedData = UserDefaults.standard.dictionary(forKey: "menuData") {
            foodProgress = savedData["foodProgress"] as? CGFloat ?? 0.26
            moodProgress = savedData["moodProgress"] as? CGFloat ?? 0.26
            tirednessProgress = savedData["tirednessProgress"] as? CGFloat ?? 0.26
            
            // ✅ Загружаем значение isSleeping корректно
            if let savedSleeping = savedData["isSleeping"] as? Bool {
                isSleeping = savedSleeping
            } else {
                isSleeping = false // ✅ Если данных нет, сбрасываем
            }
        }
    }

}
