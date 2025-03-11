import SwiftUI

struct HomeView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @State private var selectedTab: Int = 1
    @StateObject private var menuVM = MenuViewModel()
    @StateObject private var shopVM = ShopViewModel()
    @StateObject private var settingsVM = SettingsViewModel()
    var body: some View {
        if !hasSeenOnboarding {
            OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
        } else {
            TabView(selection: $selectedTab) {
                MenuView(menuVM: menuVM, shopVM: shopVM)
                    .tag(1)
                
                GameView(menuVM: menuVM)
                    .tag(2)
                
                ShopView(shopVM: shopVM)
                    .tag(3)
                
                SettingsView(settingsVM: settingsVM)
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
