import Foundation
import Combine
import UIKit

class MenuViewModel: ObservableObject {
    @Published var foodProgress: CGFloat = 0.26
    @Published var moodProgress: CGFloat = 0.26
    @Published var tirednessProgress: CGFloat = 0.26
    
    @Published var isSleeping: Bool = false
    @Published var sleepMinutes: Int = 0
    @Published var sleepSeconds: Int = 0

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
        startFoodDecay()
        restoreSleepState()
        setupAppLifecycleObservers()
    }

    /// Запуск уменьшения еды со временем
    private func startFoodDecay() {
        foodTimer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if self.foodProgress > 0.26 {
                    self.foodProgress -= 0.025
                }
            }
        }
    }
    
    /// Кормление курицы
    func feedChicken() {
        if let food = selectedFood {
            self.foodProgress = min(self.foodProgress + food.ccal, 1)
            MoneyManager.shared.subtractMoney(howMuch: food.price)
            isFeedMenuOpen = false
        } else {
            print("Food not chosen")
        }
    }
    
    /// Уход за курицей (повышает `moodProgress`)
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
    }
    
    /// Начало сна курицы с `switch` по `selectedTime`
    func sleepChicken() {
        guard let selectedTime = selectedTime else {
            print("Sleep time not selected")
            return
        }
        
        let sleepDuration: TimeInterval
        
        switch selectedTime {
        case "5min":
            sleepDuration = 5 * 60
        case "10min":
            sleepDuration = 10 * 60
        case "15min":
            sleepDuration = 15 * 60
        case "30min":
            sleepDuration = 30 * 60
        case "60min":
            sleepDuration = 60 * 60
        default:
            print("Invalid sleep time selected")
            return
        }
        
        sleepEndTime = Date().addingTimeInterval(sleepDuration)
        isSleeping = true

        // Сохраняем конец сна в память
        UserDefaults.standard.set(sleepEndTime, forKey: "sleepEndTime")

        startSleepTimer()
    }

    /// Запуск таймера сна
    private func startSleepTimer() {
        sleepTimer?.invalidate()
        sleepTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self, let sleepEndTime = self.sleepEndTime else { return }

            let remainingTime = max(0, sleepEndTime.timeIntervalSinceNow)
            self.updateSleepTime(remainingTime)

            if remainingTime <= 0 {
                self.stopSleepTimer()
            }
            
            // Каждые 15 секунд уменьшаем усталость
            if Int(remainingTime) % 15 == 0 {
                self.tirednessProgress = max(self.tirednessProgress - 0.003333333333, 0)
            }
        }
    }

    /// Восстановление состояния сна после выхода из приложения
    private func restoreSleepState() {
        if let savedEndTime = UserDefaults.standard.object(forKey: "sleepEndTime") as? Date {
            let remainingTime = max(0, savedEndTime.timeIntervalSinceNow)
            if remainingTime > 0 {
                sleepEndTime = savedEndTime
                isSleeping = true
                startSleepTimer()
            } else {
                stopSleepTimer()
            }
        }
    }

    /// Подписка на события ухода в фон и возврата в приложение
    private func setupAppLifecycleObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterBackground), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    /// Приложение уходит в фон (сохраняем `sleepEndTime`)
    @objc private func appWillEnterBackground() {
        if let sleepEndTime = sleepEndTime {
            UserDefaults.standard.set(sleepEndTime, forKey: "sleepEndTime")
        }
    }

    /// Приложение снова активно (восстанавливаем таймер сна)
    @objc private func appDidBecomeActive() {
        restoreSleepState()
    }

    /// Обновляет переменные `sleepMinutes` и `sleepSeconds`
    private func updateSleepTime(_ timeInterval: TimeInterval) {
        sleepMinutes = Int(timeInterval) / 60
        sleepSeconds = Int(timeInterval) % 60
    }
    
    /// Остановка сна и сброс переменных
    func stopSleepTimer() {
        sleepTimer?.invalidate()
        sleepEndTime = nil
        isSleeping = false
        sleepMinutes = 0
        sleepSeconds = 0
        UserDefaults.standard.removeObject(forKey: "sleepEndTime")
    }
    
    deinit {
        foodTimer?.invalidate()
        sleepTimer?.invalidate()
        NotificationCenter.default.removeObserver(self)
    }
}
