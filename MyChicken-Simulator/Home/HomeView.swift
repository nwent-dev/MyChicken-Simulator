import SwiftUI

struct HomeView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @State private var selectedTab: Int = 1
    
    var body: some View {
        if hasSeenOnboarding {
            OnboardingView()
        } else {
            TabView(selection: $selectedTab) {
                MenuView()
                    .tag(1)
                
                GameView()
                    .tag(2)
                
                ShopView()
                    .tag(3)
                
                SettingsView()
                    .tag(4)
            }
            .overlay(alignment: .bottom) {
                CustomTabView(tabSelection: $selectedTab)
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    HomeView()
}
