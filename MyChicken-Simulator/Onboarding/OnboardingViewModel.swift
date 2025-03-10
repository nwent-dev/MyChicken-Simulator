import Foundation

class OnboardingViewModel: ObservableObject {
    @Published var isOnboardingCompleted: Bool = false
    @Published var currentTextIndex: Int = 0
    @Published var titles: [String] = [
        "Welcome to My Chicken - Simulator!",
        "Chicken Care",
        "Mini-games",
        "Store"
    ]
    @Published var texts: [String] = [
        "Are you ready to take care of your virtual chicken? In this game, you will become its best friend and a caring owner!",
        "The chicken needs your care! Feed her, play with her, and monitor her condition: \n- Hunger: Feed the chicken to keep her happy.\n- Mood: Play mini-games to boost her spirits.\n- Tiredness: Let the chicken rest so she stays energetic!",
        "Earn golden eggs!\nPlay exciting mini-games and earn golden eggs! Use them to upgrade your chicken and unlock new locations:\n- Catch the grain: Catch the falling grain!\n- Surprise egg: Find the golden egg under one of the baskets!",
        "Earned golden eggs can be spent in the store on:\n- Clothing for the chicken\n- Changing locations"
        
    ]
    
    func nextText() {
        if currentTextIndex < titles.count - 1 {
            currentTextIndex += 1
        }
    }
}
